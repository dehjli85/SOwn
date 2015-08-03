class TeacherAccountController < ApplicationController

	before_action :require_teacher_login

	respond_to :json
	
	def home
		#TODO: check if the user is properly logged in 
		@classrooms = Classroom.where({teacher_user_id: session[:teacher_user_id]}).to_a
	end	

	def index
		
	end

	#return a json object representing the currently logged in teacher user
	def current_teacher_user

		current_user		

		render json: @current_teacher_user.to_json		
		
	end

	#return an array with json objects representing classrooms and the data needed for the teacher_home page
	def classrooms_summary

		current_user

		@classrooms = @current_teacher_user.classrooms

		a = Array.new
		@classrooms.each do |classroom|
			a.push({id: classroom.id, name: classroom.name, student_count: classroom.student_users.length, percent_proficient: (classroom.percent_proficient_activities*100).to_i})
		end

		render json: a.to_json
		
	end

	#return the json object representing a classroom with the specified id for the logged in user
	def classroom
		@classroom = Classroom.where({teacher_user_id: session[:teacher_user_id], id: params[:id]}).first

		render json: @classroom.to_json
	end

	#return the json object representing the unique tags for the classroom with the specified id for the logged in user
	def classroom_tags

		@classroom = Classroom.where({teacher_user_id: session[:teacher_user_id], id: params[:id]}).first

		render json: @classroom.tags.to_json
		
	end

	#return a json object with 2 attributes:
	# => activities: list of activities for the classrooms
	# => student_performances: array of student performances for activities in the classroom 
	# the activities and performances will be sorted the same
	def classroom_activities_and_performances
		
		@classroom = Classroom.where({teacher_user_id: session[:teacher_user_id], id: params[:id]}).first
		
		@search_matched_pairings_and_activities = @classroom.search_matched_pairings_and_activities({search_term: params[:search_term], tag_id: params[:tag_id]})

		performance_array = @search_matched_pairings_and_activities[:student_performances].to_a
		performance_array.each do |sp|

			sp["performance_pretty"] = StudentPerformance.performance_pretty_no_active_record(sp["activity_type"], sp["scored_performance"], sp["completed_performance"])			
			sp["performance_color"] = StudentPerformance.performance_color_no_active_record(sp["activity_type"], sp["benchmark1_score"], sp["benchmark2_score"], sp["min_score"], sp["max_score"], sp["scored_performance"], sp["completed_performance"])
			
		end

		@students = @classroom.student_users		
		
		render json: {students: @students, activities: @search_matched_pairings_and_activities[:activities], student_performances: performance_array}

	end

	def teacher_activities_and_classroom_assignment

		@classroom = Classroom.where({teacher_user_id: session[:teacher_user_id], id: params[:id]}).first
		@activities = @current_teacher_user.activities

		if params[:activity_id].nil? || !Activity.exists?(params[:activity_id])			
			@activity = @activities.first
		else						
			@activity = Activity.find(params[:activity_id])
		end

		@classroom_activity_pairing = ClassroomActivityPairing.where({classroom_id: @classroom.id, activity_id: @activity.id}).first

		render json: {activities: @activities, activity: @activity, pairing: @classroom_activity_pairing}
		
	end

	def teacher_activities_verifications

		sql = "SELECT s.id as student_user_id, s.first_name, s.last_name, s.display_name, a.id as activity_id, spv.id as verifications_id, spv.classroom_activity_pairing_id
		 	FROM classrooms c		 			 	
		 	INNER JOIN classrooms_student_users csu on csu.classroom_id = c.id
		 	INNER JOIN student_users s on s.id = csu.student_user_id
		 	LEFT JOIN classroom_activity_pairings cap on c.id = cap.classroom_id AND cap.activity_id = ?
		 	LEFT JOIN activities a on a.id = cap.activity_id
		 	LEFT JOIN student_performance_verifications spv on cap.id = spv.classroom_activity_pairing_id and s.id = spv.student_user_id
		 	WHERE c.id = ?		 	
		 	ORDER BY s.last_name ASC, s.first_name ASC"

		sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, params[:activity_id], params[:id]])

		verifications = ActiveRecord::Base.connection.execute(sanitized_query)

		render json: verifications
		
	end



	def save_teacher_activity_assignment_and_verifications
		
		@classroom = Classroom.find(params[:classroom_id])
		@activity = Activity.find(params[:activity_id])
		@activities = @current_teacher_user.activities

		save_status = Hash.new;

		@classroom_activity_pairing = ClassroomActivityPairing.where({classroom_id: @classroom.id, activity_id: @activity.id}).first
		begin
			!params[:assigned].nil?
		rescue 
			
		end

		save_status[:activity] = 'no-change'
		if !params[:assigned].nil? && params[:assigned].eql?('true') && @classroom_activity_pairing.nil?
			@classroom_activity_pairing = ClassroomActivityPairing.new({classroom_id:@classroom.id, activity_id: @activity.id})
			if @classroom_activity_pairing.save
				save_status[:activity] = 'success-assign'
			else
				save_status[:activity] = 'fail-assign'
			end
		elsif (params[:assigned].nil? || params[:assigned].eql?('false')) && !@classroom_activity_pairing.nil?

			#TODO: under this scenario, should we get rid of all the verifications?  They effectively go away because if it gets reassigned, it will be with a different classroom_activity_pairing_id
			if @classroom_activity_pairing.destroy
				@classroom_activity_pairing = nil
				save_status[:activity] = 'success-unassign'
			else
				save_status[:activity] = 'fail-unassign'
			end
		end

		if @classroom_activity_pairing			
		

			verifications_hash = params[:student_performance_verification] 
			verifications_hash ||= Hash.new

			@classroom.student_users.each do |student|
				begin
					puts !verifications_hash.nil?
					puts verifications_hash.has_key?(student.id.to_s)
					puts !StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first
				rescue
				end
				if verifications_hash.has_key?(student.id.to_s) && !StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first

					@student_performance_verification = StudentPerformanceVerification.new({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id})
					if @student_performance_verification.save
						puts "Verification created for #{student.display_name} (#{student.id})"
					else
						puts "Error creating verification for #{student.display_name} (#{student.id})"
					end
				elsif !verifications_hash[student.id.to_s] && StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first
					@student_performance_verification = StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first
					if @student_performance_verification.destroy
						puts "Verification destroyed for #{student.display_name} (#{student.id})"
					else
						puts "Error destroying verification for #{student.display_name} (#{student.id})"
					end
				end
			end

			@student_performance_verifications = @classroom_activity_pairing.student_performance_verifications	

		else

			@student_performance_verifications = nil

		end

		puts save_status[:notice]

		render json: save_status

	end

	# return json array of objects that represent different activities, each with the following properties
	# => activityId, activityName, description, instructions, activityType, tags
	# each of the properties is a string, except tags, which is an array of tag json objects with the following properties
	# => tagId, name
	def teacher_activities_and_tags

		if(params[:searchTerm].nil? && params[:tagId].nil?)
			
			activities = Activity.where({teacher_user_id: session[:teacher_user_id]}).as_json

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: session[:teacher_user_id]})
				.pluck(:id).as_json


		elsif params[:tagId]

			activities = Activity.joins(:activity_tags)
				.where({teacher_user_id: session[:teacher_user_id]})
				.where("activity_tags.id = ?", params[:tagId])
				.as_json

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: session[:teacher_user_id]})
				.where("activity_tags.id = ?", params[:tagId])
				.pluck(:id)
				.as_json

		elsif params[:searchTerm]
			
			puts "search term"
			activities = Activity.joins(:activity_tags)
				.where({teacher_user_id: session[:teacher_user_id]})
				.where("lower(activity_tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%")
				.distinct
				.as_json			

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: session[:teacher_user_id]})
				.where("lower(activity_tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%")				
				.pluck(:id)
				.as_json

		end
		
		tags = ActivityTag.joins(:activity_tag_pairings)
			.where("activity_tag_pairings.activity_id" => activity_ids)
			.select("activity_tags.*, activity_tag_pairings.activity_id")
			.as_json		

		puts "activities"
		puts activities


		activities_indices = Hash.new
		activities.each_with_index do |activity, index|
			activities_indices[activity["id"]] = index
			activity["tags"] = Array.new
		end

		puts "activities indices"
		puts activities_indices
		tags.each do |tag|
			index = activities_indices[tag["activity_id"]]			
			activities[index]["tags"].push(tag)
		end

		puts activities

		render json: activities

	end

	def save_new_activity
		@activity = Activity.new(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score))
		@activity.teacher_user_id = session[:teacher_user_id]

		if(@activity.save)

			#save the tags
			params[:tags] = params[:tags].nil? ? {} : params[:tags]
			params[:tags].each do |index, value| 
				#check if the tag exists, if it doesn't create it
				puts "index: #{index}, value: #{value}"
				tag = ActivityTag.where({name: value}).first_or_initialize({name: value})
				if(!tag.save)
					tag.errors.each do |k,v|
						puts "ERROR - #{k}: #{v}"
					end
				end

				#save the activity tag pair
				atp = ActivityTagPairing.new({activity_id: @activity.id, activity_tag_id: tag.id})
				if !atp.save
					atp.errors.each do |k, v|
						puts "ERROR - #{k}: #{v}"
					end
				end
			end

			activity_hash = @activity.serializable_hash
			activity_hash["tags"] = @activity.activity_tags.to_a.map(&:serializable_hash)

			render json: {status: "success", activity: activity_hash}
		else
			@activity.errors.each do |k,v|
				puts "#{k}: #{v}"
			end


			render json: {status: "fail", errors: @activity.errors}
		end
	end

	def activity
		activity_hash = Activity.exists?(params[:activity_id]) ? Activity.where(teacher_user_id: session[:teacher_user_id]).find(params[:activity_id]).serializable_hash : {}
		if activity_hash["id"]
			activity_hash["tags"] = Activity.find(params[:activity_id]).activity_tags.to_a.map(&:serializable_hash)
			status = "success";
		else
			activity_hash["error"] = "activity-not-found"
			status="fail";
		end

		render json: {status: status, activity: activity_hash}

	end

	def update_activity
		@activity = Activity.exists?(params[:id]) ? Activity.find(params[:id]) : nil
		if !@activity.nil?
			@activity.update(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score))

			if(@activity.save)

				#go through all the submitted tags and add/delete as necessary				
				params[:tags] = params[:tags].nil? ? {} : params[:tags]
				params[:tags].each do |index, value| 
					#check if the tag exists, if it doesn't create it
					puts "index: #{index}, value: #{value}"
					tag = ActivityTag.where({name: value}).first_or_initialize({name: value})
					if(!tag.save)
						tag.errors.each do |k,v|
							puts "ERROR - #{k}: #{v}"
						end
					end

					#create a new activity tag pair if it doesn't exist
					atp = ActivityTagPairing.where({activity_id: @activity.id, activity_tag_id: tag.id}).first_or_initialize					
					if !atp.save
						atp.errors.each do |k, v|
							puts "ERROR - #{k}: #{v}"
						end
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

				render json: {status: "success", activity: activity_hash}
				
			else				
				@classrooms = @current_teacher_user.classrooms	
				render json: {status: "fail", errors: @activity.errors}
			end
		else
			render json: {status: "fail", errors: @activity.errors}
		end
	end

	def classroom_assignments
		activity = Activity.exists?(params[:activity_id]) ? Activity.where(teacher_user_id: session[:teacher_user_id]).find(params[:activity_id]).serializable_hash : {}
		classrooms = Classroom.where(teacher_user_id: session[:teacher_user_id]).as_json
		classroom_ids = Classroom.where(teacher_user_id: session[:teacher_user_id]).pluck(:id)
		pairings_hash = ClassroomActivityPairing.where("classroom_id" => classroom_ids).where("activity_id" => params[:activity_id]).as_json

		classroom_indices = Hash.new
		classrooms.each_with_index do |classroom, index|
			classroom_indices[classroom["id"]] = index
		end

		pairings_hash.each do |pairing|
			index = classroom_indices[pairing["classroom_id"]]
			classrooms[index]["classroom_activity_pairing_id"] = pairing["id"]
		end

		render json: {status: "success", classrooms: classrooms, activity: activity}
	end

	def assign_activities
		puts params
		#get the activity
		activity = Activity.exists?(params[:activity_id]) ? Activity.find(params[:activity_id]) : nil
		#if it exists, update all classrooms associated with it based on the parameters passed
		if !activity.nil?
			puts "activity #{activity.id} exists"
			classroom_hash = params[:classroom_hash].to_h
			@current_teacher_user.classrooms.each do |c|
				puts "looking for classroom #{c.id}"
				if classroom_hash.has_value?(c.id.to_s)
					puts "classroom #{c.id} checked"
					if ClassroomActivityPairing.where({activity_id: activity.id, classroom_id: c.id}).empty?
						ca = ClassroomActivityPairing.new
						ca.classroom_id = c.id
						ca.activity_id = activity.id
						ca.save
					end
				else
					puts "classroom #{c.id} not checked"
					ClassroomActivityPairing.delete_all({activity_id: activity.id, classroom_id: c.id})					
				end
			end
		end
		

		render json: {status: "success"}
	end

end
