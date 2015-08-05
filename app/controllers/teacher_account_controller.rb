class TeacherAccountController < ApplicationController

	before_action :require_teacher_login_json, :current_user

	respond_to :json
	
	def home
		#TODO: check if the user is properly logged in 
		@classrooms = Classroom.where({teacher_user_id: @current_teacher_user.id}).to_a
	end	

	def index
		require_teacher_login
	end

	#return a json object representing the currently logged in teacher user
	def current_teacher_user		

		teacher = @current_teacher_user.serializable_hash
    teacher.delete("salt")
    teacher.delete("password_digest")
    teacher.delete("oauth_expires_at")
    teacher.delete("oauth_token")
    teacher.delete("provider")
    teacher.delete("uid")
    teacher.delete("updated_at")
    teacher.delete("create_at")

		render json: {status: "success", teacher: teacher}
		
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

	#################################################################################
	#
	# Classroom App Methods
	#
	#################################################################################

	#return the json object representing a classroom with the specified id for the logged in user
	def classroom
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first

		render json: @classroom.to_json
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
		
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first
		
		@search_matched_pairings_and_activities = @classroom.search_matched_pairings_and_activities({search_term: params[:search_term], tag_id: params[:tag_id]})

		performance_array = @search_matched_pairings_and_activities[:student_performances].to_a
		performance_array.each do |sp|

			sp["performance_pretty"] = StudentPerformance.performance_pretty_no_active_record(sp["activity_type"], sp["scored_performance"], sp["completed_performance"])			
			sp["performance_color"] = StudentPerformance.performance_color_no_active_record(sp["activity_type"], sp["benchmark1_score"], sp["benchmark2_score"], sp["min_score"], sp["max_score"], sp["scored_performance"], sp["completed_performance"])
			
		end

		@students = @classroom.student_users		
		
		render json: {status: "success", students: @students, activities: @search_matched_pairings_and_activities[:activities], student_performances: performance_array}

	end

	def save_student_performances
		
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first
		student_performance_hash = params[:studentPerformance]

		errors = Array.new

		student_performance_hash.each do |activity_id, student_activity_performances|

			cap = ClassroomActivityPairing.where({activity_id: activity_id, classroom_id: @classroom.id}).first
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
						
						stored_performance.scored_performance = performance.to_f						
						if !stored_performance.save
							errors.push(stored_performance.errors)
						end
					end

				elsif activity.activity_type.eql?('completion')

					if(stored_performance.nil? && performance.eql?('true'))	

						StudentPerformance.new({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id, completed_performance: true}).save

					elsif !stored_performance.nil?

						stored_performance.completed_performance = performance
						if !stored_performance.save
							errors.push(stored_performance.errors)
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

	def teacher_activities_verifications

		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first
		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first

		if(@classroom.nil? || @activity.nil?)

			render json: {status: "error", message: "invalid-classroom-or-activity"}

		else

			sql = "SELECT s.id as student_user_id, s.first_name, s.last_name, s.display_name, a.id as activity_id, spv.id as verifications_id, spv.classroom_activity_pairing_id
			 	FROM classrooms c		 			 	
			 	INNER JOIN classrooms_student_users csu on csu.classroom_id = c.id
			 	INNER JOIN student_users s on s.id = csu.student_user_id
			 	LEFT JOIN classroom_activity_pairings cap on c.id = cap.classroom_id AND cap.activity_id = ?
			 	LEFT JOIN activities a on a.id = cap.activity_id
			 	LEFT JOIN student_performance_verifications spv on cap.id = spv.classroom_activity_pairing_id and s.id = spv.student_user_id
			 	WHERE c.id = ?		 	
			 	ORDER BY s.last_name ASC, s.first_name ASC"

			sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, params[:activity_id], params[:classroom_id]])

			verifications = ActiveRecord::Base.connection.execute(sanitized_query)

			render json: {status: "success", verifications: verifications}
		end
		
	end



	def save_teacher_activity_assignment_and_verifications
		
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first
		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first

		puts @classroom.nil?
		puts @activity.nil?

		if(!@classroom.nil? && !@activity.nil?)

			@classroom_activity_pairing = ClassroomActivityPairing.where({classroom_id: @classroom.id, activity_id: @activity.id}).first
			
			activity_status = 'no-change'
			if !params[:assigned].nil? && params[:assigned].eql?('true') && @classroom_activity_pairing.nil?

				@classroom_activity_pairing = ClassroomActivityPairing.new({classroom_id:@classroom.id, activity_id: @activity.id})
				if @classroom_activity_pairing.save
					activity_status = 'success-assign'
				else
					activity_status = 'fail-assign'
				end

			elsif (params[:assigned].nil? || params[:assigned].eql?('false')) && !@classroom_activity_pairing.nil?

				#TODO: under this scenario, should we get rid of all the verifications?  They effectively go away because if it gets reassigned, it will be with a different classroom_activity_pairing_id
				if @classroom_activity_pairing.destroy
					@classroom_activity_pairing = nil
					activity_status = 'success-unassign'
				else
					activity_status = 'fail-unassign'
				end

			end

			verifications_errors = Array.new

			if @classroom_activity_pairing			

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
				
				render json: {status: "success", activity_status: activity_status, verifications_status: "success"} 

			else

				render json: {status: "success", activity_status: activity_status, verifications_status: "error", verification_errors: verifications_errors} 				

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

		puts activities_indices
		tags.each do |tag|
			index = activities_indices[tag["activity_id"]]			
			activities[index]["tags"].push(tag)
		end

		render json: {status: "success", activities: activities}

	end

	def save_new_activity

		@activity = Activity.new(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score))
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
			@activity.update(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score))

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

end
