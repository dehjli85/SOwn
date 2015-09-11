class TeacherAccountController < ApplicationController

	require 'json'

	before_action :require_teacher_login_json, except: [:index]

	respond_to :json
	

	#################################################################################
	#
	# TeacherAccount App Methods
	#
	#################################################################################

	def index
		require_teacher_login
	end


	#################################################################################
	#
	# Settings App Methods
	#
	#################################################################################

	def delete_account

		if !(@current_teacher_user.id.eql?(params[:teacher_user_id].to_i))

			render json: {status: "error", message: "user-not-logged-in"}

		else

			@current_teacher_user.email = "sowntogrow_deleted_teacher_" + @current_teacher_user.id.to_s + "@sowntogrow.com"
			if @current_teacher_user.save
				session[:teacher_user_id] = nil
				session[:student_user_id] = nil

				render json: {status: "success"}

			else

				render json: {status: "error", message: "unable-to-disable-account"}

			end

		end
		
	end

	def save_settings

		@current_teacher_user.default_view_student = params[:default_view_student]

		puts "current_teacher: #{@current_teacher_user.default_view_student}"

		if @current_teacher_user.save

			puts "after save current_teacher: #{@current_teacher_user.default_view_student}"

			render json: {status: "success"}

		else

			render json: {status: "error", message: "unable-to-save-settings"}

		end

		
	end

	

	#################################################################################
	#
	# Classrooms App Methods
	#
	#################################################################################

	#return an array with json objects representing classrooms and the data needed for the teacher_home page
	def classrooms_summary

		if(!@current_teacher_user.nil?)
			@classrooms = @current_teacher_user.classrooms

			a = Array.new
			@classrooms.each do |classroom|
				a.push({id: classroom.id, name: classroom.name, student_count: classroom.student_users.length, percent_proficient: (classroom.percent_proficient_activities*100).to_i})
			end

			render json: {status: "success", classrooms: a}
		else
			render json: {status: "error", message: "user-not-logged-in"}

		end
		
	end

	def save_new_classroom
		
		@classroom = Classroom.new(params.require(:classroom).permit(:name, :description, :classroom_code))
		@classroom.teacher_user_id = @current_teacher_user.id
		
		if(@classroom.save)

			render json: {status: "success"}
		else

			render json: {status: "error", errors: @classroom.errors}

		end
	end

	def update_classroom
		
		@classroom = Classroom.where({id: params[:classroom][:id], teacher_user_id: @current_teacher_user.id}).first

		if(@classroom)
		
			if(@classroom.update_attributes(params.require(:classroom).permit(:name, :description, :classroom_code)))

				render json: {status: "success"}
			else

				render json: {status: "error", errors: @classroom.errors}

			end

		else

			render json: {status: "error", message: "invalid-classroom"}			

		end
	end

	#################################################################################
	#
	# Classroom App Methods
	#
	#################################################################################


	#return the json object representing a classroom with the specified id for the logged in user
	def classroom
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first

		if @classroom
			render json: {status: "success", classroom: @classroom}
		else
			render json: {status: "error", message: "invalid-classroom-id"}
		end
	end

	#return the json object representing the unique tags for the classroom with the specified id for the logged in user
	def classroom_tags

		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first

		render json: @classroom.tags.to_json
		
	end

	#return a json object with 2 attributes:
	# => activities: list of activities for the classrooms
	# => student_performances: array of student performances for activities in the classroom 
	# the activities and performances will be sorted the same
	def classroom_activities_and_performances
			
		tag_ids = params[:tag_ids] && !params[:tag_ids].eql?("[]") ? JSON.parse(params[:tag_ids]) : nil

		classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]})
			.first
		
		activities = Activity.activities_with_pairings(classroom.id, params[:search_term], tag_ids, true)
		
		performance_array = StudentPerformance.student_performances_with_verification(classroom.id, params[:search_term], tag_ids, nil, true)

		proficient_counts = StudentPerformance.student_performance_proficiencies(classroom.id, params[:search_term], tag_ids, nil, true)

		students = classroom.student_users.order("last_name ASC, first_name ASC").as_json	

		# Organize the performance data by student

		# create a lookup hash for student_id
		# create an array to store th performances for each student
		students_hash = {}
		students.each_with_index do |student, index|
			students_hash[student["id"].to_i] = index
			student["student_performance"] = []
			student["proficient_count"] = 0
		end

		# assign each performance to the correct student/activity
		performance_array.each do |performance|

			student_index = students_hash[performance["student_user_id"].to_i]
			activities_index = performance["sort_order"].to_i

			if students[student_index]["student_performance"][activities_index].nil? || students[student_index]["student_performance"][activities_index]["id"].to_i < performance["id"].to_i
				students[student_index]["student_performance"][activities_index] = performance
			end

		end

		# add proficient counts
		proficient_counts.each do |student|
			student_index = students_hash[student["student_user_id"].to_i]
			students[student_index]["proficient_count"] = student["proficient_count"].to_i
		end

		# count activities due
		activities_due = 0
		activities.each do |activity|
			if !activity["due_date"].nil? && Date.parse(activity["due_date"]).to_time < Time.now
				activities_due += 1
			end
		end



		render json: {status: "success", students_with_performance: students, activities: activities, classroom: classroom, activities_due: activities_due}

	end

	def save_student_performances
		
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first

		due_date_hash = params[:due_date]
		due_date_hash.each do |cap_id, date|
			
			cap = ClassroomActivityPairing.where(id: cap_id).first
			cap.due_date = date
			
			if(!cap.save)
				errors.push(cap.errors)
			end

		end

		student_performance_hash = params[:studentPerformance]

		errors = Array.new

		student_performance_hash.each do |cap_id, student_activity_performances|

			cap = ClassroomActivityPairing.where(id: cap_id).first
			activity = cap.activity

			student_activity_performances.each do |student_user_id, performance| 
			
				stored_performance = StudentPerformance.where({student_user_id: student_user_id, classroom_activity_pairing_id: cap.id}).order("created_at DESC").first

				if activity.activity_type.eql?('scored')
					
					if(stored_performance.nil? && !performance.strip.eql?(''))	

						newStudentPerformance = StudentPerformance.new({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id, scored_performance: performance, performance_date: Time.now})
						if(!newStudentPerformance.save)
							errors.push(newStudentPerformance.errors)
						end

					elsif !stored_performance.nil?
						
						if performance.strip.eql?('')
							if !stored_performance.destroy
								errors.push(stored_performance.errors)
							end
						else
							stored_performance.scored_performance = performance.to_f						
							if !stored_performance.save
								errors.push(stored_performance.errors)
							end
						end
						
					end

				elsif activity.activity_type.eql?('completion')

					if(stored_performance.nil? && performance.eql?('true'))	
						newStudentPerformance = StudentPerformance.new({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id, completed_performance: true, performance_date: Time.now})
						if(!newStudentPerformance.save)
							errors.push(newStudentPerformance.errors)
						end

					elsif !stored_performance.nil?

						if performance.strip.eql?('')
							if !stored_performance.destroy
								errors.push(stored_performance.errors)
							end
						else
							stored_performance.completed_performance = performance
							if !stored_performance.save
								errors.push(stored_performance.errors)
							end
						end

					end
				end			
					
			end
		end

		if(errors.empty?)

			render json: {status: "success", classroomId: @classroom.id, errors: errors}

		else

			render json: {status: "error", classroomId: @classroom.id, errors: errors}

		end

	end

	def student_performance

		student_performance = StudentPerformance.where(id: params[:student_performance_id]).first

		if student_performance 
			
			classroom = Classroom.joins(:classroom_activity_pairings).where("classroom_activity_pairings.id = ?", student_performance.classroom_activity_pairing_id).where(teacher_user_id: @current_teacher_user.id).first

			if classroom

				student = StudentUser.where(id: student_performance.student_user_id)
					.select("display_name").first

				activity = Activity.joins(:classroom_activity_pairings).where("classroom_activity_pairings.id = ?", student_performance.classroom_activity_pairing_id).first

				student_performance_hash = student_performance.serializable_hash
				#fix the performance_date field
				student_performance_hash["performance_pretty"] = StudentPerformance.performance_pretty_no_active_record(activity.activity_type, student_performance_hash["scored_performance"], student_performance_hash["completed_performance"])

				render json: {status: "success", activity: activity, student: student, student_performance: student_performance_hash}

			else

				render json: {status: "error", message: "invalid-classroom-activity-pairing"}

			end

		else

			render json: {status: "error", message: "invalid-classroom-activity-pairing"}

		end
		
	end

	def save_verify
		
		student_performance = StudentPerformance.where(id: params[:student_performance_id]).first

		if student_performance 
			
			classroom = Classroom.joins(:classroom_activity_pairings).where("classroom_activity_pairings.id = ?", student_performance.classroom_activity_pairing_id).where(teacher_user_id: @current_teacher_user.id).first

			if classroom

				student_performance.verified = true

				if student_performance.save

					render json: {status: "success"}

				else

					render json: {status: "error", student_performance_errors: student_performance.errors}

				end

			else

				render json: {status: "error", message: "invalid-classroom-activity-pairing"}

			end

		else

			render json: {status: "error", message: "invalid-classroom-activity-pairing"}

		end

	end

	def save_activities_sort_order

		classroom_activities_sorted = params[:classroom_activities_sorted]

		errors = Array.new
		sorted_cap_ids = Array.new
		classroom_activities_sorted.each do |index, value|
			sorted_cap_ids[index.to_i] = value.to_i
		end

		begin
			ClassroomActivityPairing.sort_activities(sorted_cap_ids)
			render json: {status: "success"}
		rescue
			render json: {status: "error", errors: errors, message: "error saving activities sort order"}
		end

		
	end

	#################################################################################
	#
	# Activities App Methods
	#
	#################################################################################

	def teacher_activities_and_classroom_assignment

		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first
		@activities = @current_teacher_user.activities

		if params[:activity_id].nil? || !Activity.exists?(params[:activity_id])			
			@activity = @activities.first
		else						
			@activity = Activity.find(params[:activity_id])
		end

		@classroom_activity_pairing = ClassroomActivityPairing.where({classroom_id: @classroom.id, activity_id: @activity.id}).first

		render json: {status: "success", activities: @activities, activity: @activity, pairing: @classroom_activity_pairing}
		
	end

	def teacher_activities_options

		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first
		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first

		if(@classroom.nil? || @activity.nil?)

			render json: {status: "error", message: "invalid-classroom-or-activity"}

		else

			classroom_activity_pairing = ClassroomActivityPairing.where("classroom_id = ? and activity_id = ?", @classroom.id, @activity.id).first

			sql = "SELECT s.id as student_user_id, s.first_name, s.last_name, s.display_name, 
					a.id as activity_id, 
					cap.hidden, cap.due_date, 
					spv.id as verifications_id, spv.classroom_activity_pairing_id
			 	FROM classrooms c		 			 	
			 	INNER JOIN classroom_student_users csu on csu.classroom_id = c.id
			 	INNER JOIN student_users s on s.id = csu.student_user_id
			 	LEFT JOIN classroom_activity_pairings cap on c.id = cap.classroom_id AND cap.activity_id = ?
			 	LEFT JOIN activities a on a.id = cap.activity_id
			 	LEFT JOIN student_performance_verifications spv on cap.id = spv.classroom_activity_pairing_id and s.id = spv.student_user_id
			 	WHERE c.id = ?		 	
			 	ORDER BY s.last_name ASC, s.first_name ASC"

			sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, params[:activity_id], params[:classroom_id]])

			verifications = ActiveRecord::Base.connection.execute(sanitized_query)

			render json: {status: "success", verifications: verifications, classroom_activity_pairing: classroom_activity_pairing}
		end
		
	end



	def save_teacher_activity_assignment_and_options
		
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first
		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first

		if(!@classroom.nil? && !@activity.nil?)

			@classroom_activity_pairing = ClassroomActivityPairing.where({classroom_id: @classroom.id, activity_id: @activity.id}).first
			
			assignment_status = 'no-change'
			

			# wasn't assigned assigned, needs to be assigned
			if !params[:assigned].nil? && params[:assigned].eql?('true') && @classroom_activity_pairing.nil?

				@classroom_activity_pairing = ClassroomActivityPairing.new({classroom_id:@classroom.id, activity_id: @activity.id, hidden: false})
				@classroom_activity_pairing.sort_order = ClassroomActivityPairing.max_sort_order(@classroom.id).nil? ? 0 : ClassroomActivityPairing.max_sort_order(@classroom.id) + 1
				if @classroom_activity_pairing.save
					assignment_status = 'success-assign'
				else
					assignment_status = 'fail-assign'
				end

			# was assigned, needs to be unassigned
			elsif (params[:assigned].nil? || params[:assigned].eql?('false')) && !@classroom_activity_pairing.nil?

				#TODO: under this scenario, should we get rid of all the verifications?  They effectively go away because if it gets reassigned, it will be with a different classroom_activity_pairing_id
				if @classroom_activity_pairing.destroy
					@classroom_activity_pairing = nil
					assignment_status = 'success-unassign'
				else
					assignment_status = 'fail-unassign'
				end

			end

			
			# Variables to activity assignment options
			hidden_status = 'no-change'
			verifications_errors = Array.new
			due_date_status = 'no-due-date'

			if @classroom_activity_pairing			

				# Save hidden status	
				#wasn't hidden, needs to be hidden
				if !params[:hidden].nil? && params[:hidden].eql?('true') && !@classroom_activity_pairing.hidden
					@classroom_activity_pairing.hidden = true
					if @classroom_activity_pairing.save
						hidden_status = 'success-hide'
					else
						hidden_status = 'fail-hide'
					end

				# was hidden, needs to be unhidden
				else

					@classroom_activity_pairing.hidden = false
					if 	@classroom_activity_pairing.save
						hidden_status = 'success-unhide'
					else
						hidden_status = 'fail-unhide'
					end
				end

				# Save due date
				# Due date exists, need to remove
				if params[:dueDate].nil? && !@classroom_activity_pairing.due_date.nil?
					@classroom_activity_pairing.due_date = params[:dueDate]
					if @classroom_activity_pairing.save
							due_date_status = 'success-due-date-remove'
					else
							due_date_status = 'fail-due-date-remove'
					end

				elsif !params[:dueDate].nil? && @classroom_activity_pairing.due_date.nil?
					@classroom_activity_pairing.due_date = params[:dueDate]
					if @classroom_activity_pairing.save
							due_date_status = 'success-new-due-date-saved'
					else
							due_date_status = 'fail-new-due-date-saved'
					end			

				elsif !params[:dueDate].nil? 
					@classroom_activity_pairing.due_date = params[:dueDate]
					if @classroom_activity_pairing.save
							due_date_status = 'success-new-due-date-updated'
					else
							due_date_status = 'fail-new-due-date-updated'
					end			

				end

				# Save verifications
				verifications_hash = params[:student_performance_verification] 
				verifications_hash ||= Hash.new
				

				@classroom.student_users.each do |student|

					if verifications_hash.has_key?(student.id.to_s) && !StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first

						@student_performance_verification = StudentPerformanceVerification.new({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id})
						if !@student_performance_verification.save
							verifications_errors.push(@student_performance_verification.errors)
						end

					elsif !verifications_hash[student.id.to_s] && StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first

						@student_performance_verification = StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first
						if !@student_performance_verification.destroy
							verifications_errors.push(@student_performance_verification.errors)							
						end

					end

				end

			end

			if verifications_errors.empty?
				
				render json: {status: "success", assignment_status: assignment_status, hidden_status: hidden_status, due_date_status: due_date_status, verifications_status: "success"} 

			else

				render json: {status: "success", assignment_status: assignment_status, hidden_status: hidden_status, due_date_status: due_date_status, verifications_status: "error", verification_errors: verifications_errors} 				

			end			

		else

			render json: {status: "error", message: "invalid-classroom-or-activity"}

		end

	end

	# return json array of objects that represent different activities, each with the following properties
	# => activityId, activityName, description, instructions, activityType, tags
	# each of the properties is a string, except tags, which is an array of tag json objects with the following properties
	# => tagId, name
	def teacher_activities_and_tags

		if(params[:searchTerm].nil? && params[:tagId].nil?)
			
			activities = Activity.where({teacher_user_id: @current_teacher_user.id}).as_json

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.pluck(:id).as_json

		elsif params[:tagId]

			activities = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("activity_tags.id = ?", params[:tagId])
				.as_json

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("activity_tags.id = ?", params[:tagId])
				.pluck(:id)
				.as_json

		elsif params[:searchTerm]
			
			activities = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("lower(activity_tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%")
				.distinct
				.as_json			

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("lower(activity_tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%")				
				.pluck(:id)
				.as_json

		end

		tags = ActivityTag.joins(:activity_tag_pairings)
			.where("activity_tag_pairings.activity_id" => activity_ids)
			.select("activity_tags.*, activity_tag_pairings.activity_id")
			.as_json		

		activities_indices = Hash.new
		activities.each_with_index do |activity, index|
			activities_indices[activity["id"]] = index
			activity["tags"] = Array.new
		end

		tags.each do |tag|
			index = activities_indices[tag["activity_id"]]			
			activities[index]["tags"].push(tag)
		end

		render json: {status: "success", activities: activities}

	end

	def save_new_activity

		@activity = Activity.new(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score, :link))
		@activity.teacher_user_id = @current_teacher_user.id

		tag_errors = Array.new
		pairing_errors = Array.new

		if(@activity.save)

			#save the tags
			params[:tags] = params[:tags].nil? ? {} : params[:tags]
			params[:tags].each do |index, value| 

				#check if the tag exists, if it doesn't create it
				tag = ActivityTag.where({name: value}).first_or_initialize({name: value})
				if(!tag.save)
					tag_errors.push(tag.errors)
				end

				#save the activity tag pair
				atp = ActivityTagPairing.new({activity_id: @activity.id, activity_tag_id: tag.id})
				if !atp.save
					pairing_errors.push(atp.errors)
				end

			end

			activity_hash = @activity.serializable_hash
			activity_hash["tags"] = @activity.activity_tags.to_a.map(&:serializable_hash)

			render json: {status: "success", activity: activity_hash, tag_errors: tag_errors, pairing_errors: pairing_errors}
		else

			render json: {status: "error", errors: @activity.errors}

		end
	end

	def activity

		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first
		
		if(!@activity.nil?)
			
			activity_hash = @activity.serializable_hash
			
			activity_hash["tags"] = @activity.activity_tags.to_a.map(&:serializable_hash)

			render json: {status: "success", activity: activity_hash}

		else

			render json: {status: "error", message: "invalid-activity"}

		end

	end

	def update_activity

		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:id]}).first

		if !@activity.nil?
			@activity.update(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score, :link))

			if(@activity.save)

				#go through all the submitted tags and add/delete as necessary				
				params[:tags] ||=  {} 
				tag_errors = Array.new
				pairing_errors = Array.new

				params[:tags].each do |index, value| 

					#check if the tag exists, if it doesn't create it
					tag = ActivityTag.where({name: value}).first_or_initialize({name: value})
					if(!tag.save)
						tag_errors.push(tag.errors)
					end

					#create a new activity tag pair if it doesn't exist
					atp = ActivityTagPairing.where({activity_id: @activity.id, activity_tag_id: tag.id}).first_or_initialize					
					if !atp.save
						pairing_errors.push(atp.errors)
					end
				end

				#delete all tag pairings from the database if they aren't in the submitted list
				@activity.activity_tag_pairings.each do |existing_atp|
					if !params[:tags].has_value?(existing_atp.activity_tag.name)
						existing_atp.destroy
					end
				end

				activity_hash = @activity.serializable_hash
				activity_hash["tags"] = @activity.activity_tags.to_a.map(&:serializable_hash)

				render json: {status: "success", activity: activity_hash, tag_errors: tag_errors, pairing_errors: pairing_errors}
				
			else				

				@classrooms = @current_teacher_user.classrooms	
				render json: {status: "error", message: "error-saving-activity", errors: @activity.errors}

			end

		else

			render json: {status: "error", message: "invalid-activity"}

		end
	end

	def classroom_assignments
		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first.serializable_hash

		if(@activity)
			classrooms = Classroom.where(teacher_user_id: @current_teacher_user.id).as_json
			classroom_ids = Classroom.where(teacher_user_id: @current_teacher_user.id).pluck(:id)
			pairings_hash = ClassroomActivityPairing.where("classroom_id" => classroom_ids).where("activity_id" => @activity["id"]).as_json

			classroom_indices = Hash.new
			classrooms.each_with_index do |classroom, index|
				classroom_indices[classroom["id"]] = index
			end

			pairings_hash.each do |pairing|
				index = classroom_indices[pairing["classroom_id"]]
				classrooms[index]["classroom_activity_pairing_id"] = pairing["id"]
			end

			render json: {status: "success", classrooms: classrooms, activity: @activity}
		else

			render json: {status: "error", message: "invalid-activity"}

		end

	end

	def assign_activities
		
		#get the activity
		activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first		
		
		#if it exists, update all classrooms associated with it based on the parameters passed
		if !activity.nil?
		
			classroom_hash = params[:classroom_hash].to_h
			@current_teacher_user.classrooms.each do |c|

				if classroom_hash.has_value?(c.id.to_s)

					if ClassroomActivityPairing.where({activity_id: activity.id, classroom_id: c.id}).empty?

						ca = ClassroomActivityPairing.new
						ca.classroom_id = c.id
						ca.activity_id = activity.id
						ca.hidden = false
						ca.sort_order = ClassroomActivityPairing.max_sort_order(c.id).nil? ? 0 : ClassroomActivityPairing.max_sort_order(c.id) + 1
						ca.save

					end
				else

					ClassroomActivityPairing.delete_all({activity_id: activity.id, classroom_id: c.id})					

				end
			end

			render json: {status: "success"}

		else

			render json: {status: "error", message: "invalid-activity-id"}

		end
		
	end

	def student_performance_count
		activity = Activity.where({id: params[:activity_id], teacher_user_id: @current_teacher_user.id}).first
		if activity.nil?
			render json: {status: "error", message: "activity does not exist"}
		else	
			counts = activity.student_performance_count
			render json: {status: "success", student_performance_count: counts[:student_performance_count], student_count: counts[:student_count], activity: activity}
		end
		
	end

	def delete_activity
		activity = Activity.where({id: params[:activity_id], teacher_user_id: @current_teacher_user.id}).first
		if activity.nil?
			render json: {status: "error", message: "activity does not exist"}
		else	
			if activity.destroy
				render json: {status: "success"}
			else
				render json: {status: "error", message: "errors deleting activity"}
			end
		end
		
	end

	#################################################################################
	#
	# Students App Methods
	#
	#################################################################################

	def students

		searchTerm = params[:searchTerm].nil? ? "" : params[:searchTerm].downcase 
		
		students = StudentUser.joins(:classrooms)
			.joins("inner join teacher_users t on classrooms.teacher_user_id = t.id")
			.where("t.id = ?", @current_teacher_user.id)
			.where("lower(student_users.first_name) like ? or lower(student_users.last_name) like ? or lower(student_users.display_name) like ?", "%#{searchTerm}%", "%#{searchTerm}%", "%#{searchTerm}%")
			.select("student_users.*")
			.distinct

		students_ids = students.pluck("student_users.id")

		classrooms = Classroom.joins(:student_users)
			.where("student_users.id in (?) ", students_ids)
			.where("classrooms.teacher_user_id = ?", @current_teacher_user.id)
			.select("classrooms.*, student_users.id as student_user_id")
			.as_json

		students_json = students.as_json
		students_indices = Hash.new

		students_json.each_with_index do |student, index|
			students_indices[student["id"]] = index
			student["classrooms"] = Array.new
		end

		classrooms.each do |classroom|
			index = students_indices[classroom["student_user_id"]]
			students_json[index]["classrooms"].push(classroom)
		end

		render json: {status: "success", students: students_json}

	end

	def student

		student = StudentUser.joins(:classrooms)
			.joins("inner join teacher_users t on classrooms.teacher_user_id = t.id")
			.where("t.id = ?", @current_teacher_user.id)
			.where("student_users.id = ?" , params[:studentId])
			.first
		
	end

	def student_activities_and_performances

		classroom = Classroom.joins(:classroom_student_users)
			.where("student_user_id = ? and classrooms.id = ? and teacher_user_id = ?", params[:student_user_id], params[:classroom_id], @current_teacher_user.id)
			.first

		student = StudentUser.joins(:classroom_student_users)
			.joins(:classrooms)
			.where("student_users.id = ? and classroom_student_users.classroom_id = ? and classrooms.teacher_user_id = ?", params[:student_user_id], params[:classroom_id], @current_teacher_user.id)
			.first

    if !classroom.nil?

      activities = classroom.activities_and_performances(params[:student_user_id])        

      render json: {status: "success", activities: activities, student: student, classroom: classroom}

    else

      render json: {status: "error", message: "invalid-classroom"}

    end  
		
	end

	def student_activity
    
    classroom_activity_pairing = ClassroomActivityPairing.where(id: params[:classroom_activity_pairing_id]).first

    if classroom_activity_pairing

      classroom_student_user = ClassroomStudentUser.joins(:classroom)
      		.joins("inner join teacher_users t on t.id = classrooms.teacher_user_id")
      		.where(classroom_id: classroom_activity_pairing.classroom_id)
      		.where(student_user_id: params[:student_user_id])
      		.where("t.id = ?", @current_teacher_user.id)
      		.first


      if !classroom_student_user.nil?

        activity = classroom_activity_pairing.activity

        render json: {status: "success", activity: activity, classroom_activity_pairing: classroom_activity_pairing}

      else

      	render json: {status: "error", message: "invalid-student-for-classroom-activity-pairing"}

      end

    else

      	render json: {status: "error", message: "invalid-classroom-activity-pairing-id"}

    end

  end

  def activity_and_performances
    
    classroom_activity_pairing = ClassroomActivityPairing.where(id: params[:classroom_activity_pairing_id]).first

    if classroom_activity_pairing

      classroom_student_user = ClassroomStudentUser.joins(:classroom)
      		.joins("inner join teacher_users t on t.id = classrooms.teacher_user_id")
      		.where(classroom_id: classroom_activity_pairing.classroom_id)
      		.where(student_user_id: params[:student_user_id])
      		.where("t.id = ?", @current_teacher_user.id)
      		.first

      if !classroom_student_user.nil?

        activity = classroom_activity_pairing.activity

        performances = StudentPerformance.where({classroom_activity_pairing_id: classroom_activity_pairing.id, student_user_id: params[:student_user_id]}).order("created_at ASC").as_json

        performances.each do |performance|
          performance["performance_pretty"] = StudentPerformance.performance_pretty_no_active_record(activity.activity_type, performance["scored_performance"], performance["completed_performance"])
          performance["performance_color"] = StudentPerformance.performance_color_no_active_record(activity.activity_type, activity.benchmark1_score, activity.benchmark2_score, activity.min_score, activity.max_score, performance["scored_performance"], performance["completed_performance"])

        end

        render json: {status: "success", activity: activity, classroom_activity_pairing: classroom_activity_pairing, performances: performances}

      else

      render json: {status: "error", message: "invalid-student-for-classroom-activity-pairing"}

      end

    else

      render json: {status: "error", message: "invalid-classroom-activity-pairing-id"}

    end

  end

  def classroom_student_user

  	classroom_student_user = ClassroomStudentUser.joins(:classroom)
  		.joins(:student_user)
  		.joins("inner join teacher_users t on t.id = classrooms.teacher_user_id")
  		.where("t.id = ?", @current_teacher_user.id)
  		.where("classroom_student_users.student_user_id = ?", params[:student_user_id])
  		.where("classroom_student_users.classroom_id = ?", params[:classroom_id])
  		.select("student_users.display_name, classrooms.name, classroom_student_users.*")
  		.first

    render json: {status: "success", classroom_student_user: classroom_student_user}

  	
  end

  def classroom_remove_student

  	classroom_student_user = ClassroomStudentUser.joins(:classroom)
  		.joins(:student_user)
  		.joins("inner join teacher_users t on t.id = classrooms.teacher_user_id")
  		.where("t.id = ?", @current_teacher_user.id)
  		.where("classroom_student_users.student_user_id = ?", params[:student_user_id])
  		.where("classroom_student_users.classroom_id = ?", params[:classroom_id])
  		.where("classroom_student_users.id = ?", params[:classroom_student_user_id])
  		.select("student_users.display_name, classrooms.name, classroom_student_users.*")
  		.first

  	if !classroom_student_user.nil?

  		if(classroom_student_user.destroy)
    		render json: {status: "success"}
    	else
      	render json: {status: "error", message: "error-removing-student", errors: @classroom_student_user.errors}
    	end

  	else
      
      render json: {status: "error", message: "invalid-classroom-student-user-id"}

  	end
  	
  	

  end





end
