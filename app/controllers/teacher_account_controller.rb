class TeacherAccountController < ApplicationController

	require 'json'
	require 'csv'

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

	def update_password
    
    old_password = params[:oldPassword]
    new_password = params[:newPassword]
    confirm_password = params[:confirmNewPassword]

    # check that it's a sown to grow account and the old password matches
    if !(@current_teacher_user && @current_teacher_user.provider.nil? && @current_teacher_user.password_valid?(old_password))
      
      render json: {status: "error", message: "incorrect-original-password-for-specified-user"}
    
    else
      # if the old password matches, check that the new and confirm are the same and not blank
      if !new_password.eql?(confirm_password)
        render json: {status: "error", message: "new-and-confirm-password-do-not-match"}
      else
        @current_teacher_user.password = new_password
        if !@current_teacher_user.save
          render json: {status: "error", message: "unable-to-update-password-for-specified-user"}
        else
          render json: {status: "success"}        
        end
      end


    end

    
  end

  def convert_account

    password = params[:password]
    confirm_password = params[:confirmPassword]

    # check it's a google account
    if !(@current_teacher_user && !@current_teacher_user.provider.nil?)
      
      authorization_code = params[:authorization_code]
      if(!authorization_code.nil?)

        # unclear why we need an authorization code.  Allows us to get an access token to do stuff
        # but we can get as much just passing an the token ID from the client the the Oauth2V2 service
        client_secrets = Google::APIClient::ClientSecrets.load(Rails.root.join("config/client_secret_916932200710-kk91r5rbn820llsernmbjfgk9r5s67lq.apps.googleusercontent.com.json"))
        auth_client = client_secrets.to_authorization
        auth_client.update!(redirect_uri: 'postmessage')
        auth_client.code = authorization_code
        token = auth_client.fetch_access_token!

        service = Google::Apis::Oauth2V2::Oauth2Service.new
        service.authorization = auth_client
        user_info = service.get_userinfo

        @current_teacher_user.provider = "google_oauth2"
        @current_teacher_user.uid = user_info.id
        @current_teacher_user.oauth_token = token["access_token"]
        @current_teacher_user.oauth_expires_at = Time.now + token["expires_in"]
        @current_teacher_user.email = user_info.email.downcase
        @current_teacher_user.first_name = user_info.given_name
        @current_teacher_user.last_name = user_info.family_name
        @current_teacher_user.username = user_info.email.downcase
        @current_teacher_user.display_name = user_info.name

        @current_teacher_user.password=nil

        if @current_teacher_user.save
          render json: {status: "success"}
        else
          render json: {status: "error", message: "unable-to-save-google-user"}
        end

      else
          render json: {status: "error", message: "authorization_code-cannot-be-null"}

      end
    
    else
      # if the old password matches, check that the new and confirm are the same and not blank
      if !password.eql?(confirm_password)
        render json: {status: "error", message: "new-and-confirm-password-do-not-match"}
      else
        @current_teacher_user.password = password
        @current_teacher_user.provider = nil
        @current_teacher_user.uid = nil
        @current_teacher_user.oauth_token = nil
        @current_teacher_user.oauth_expires_at = nil

        if !@current_teacher_user.save
          render json: {status: "error", message: "unable-to-update-password-for-specified-user"}
        else
          render json: {status: "success"}        
        end
      end


    end
     
  end

	def save_settings

		# @current_teacher_user.default_view_student = params[:default_view_student]
		@current_teacher_user.assign_attributes(params.require(:teacher_user).permit(:first_name, :last_name, :gender, :salutation, :email, :default_view_student))
		@current_teacher_user.display_name = @current_teacher_user.first_name + ' ' + @current_teacher_user.last_name
		@current_teacher_user.username = @current_teacher_user.email

		if @current_teacher_user.save

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

			activities = @current_teacher_user.activities

			student_count = ClassroomStudentUser.where(classroom_id: @classrooms.pluck(:id)).count

			render json: {status: "success", classrooms: a, activities: activities, student_count: student_count}
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

		render json: @classroom.tags(true, false).to_json
		
	end

	#return a json object with 2 attributes:
	# => activities: list of activities for the classrooms
	# => student_performances: array of student performances for activities in the classroom 
	# the activities and performances will be sorted the same
	def classroom_activities_and_performances
			
		tag_ids = params[:tag_ids] && !params[:tag_ids].eql?("[]") ? JSON.parse(params[:tag_ids]) : nil

		classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]})
			.first
		
		activities = Activity.activities_with_pairings(classroom.id, params[:search_term], tag_ids, true, false)

		activity_goals = ActivityGoal.student_goals(classroom.id, params[:search_term], tag_ids, nil, true, false)
		
		performance_array = StudentPerformance.student_performances_with_verification(classroom.id, params[:search_term], tag_ids, nil, true, false)

		proficient_counts = StudentPerformance.student_performance_proficiencies(classroom.id, params[:search_term], tag_ids, nil, true, false)

		students = classroom.student_users.order("last_name ASC, first_name ASC").as_json	

		# Organize the performance data by student

		# create a lookup hash for student_id
		# create an array to store the performances for each student
		students_hash = {}
		students.each_with_index do |student, index|
			student.delete("salt")
      student.delete("password_digest")
      student.delete("oauth_expires_at")
      student.delete("oauth_token")
      student.delete("updated_at")
      student.delete("create_at")
      student.delete("provider")
      student.delete("uid")
			students_hash[student["id"].to_i] = index
			student["student_performance"] = []
			student["proficient_count"] = 0
			student["activity_goals"] = []
		end

		# create a lookup hash for activity_id
		activities_hash = {}
		activities.each_with_index do |activity, index|
			activities_hash[activity["id"].to_i] = index
		end

		# assign each Performance to the correct Student/Activity
		performance_array.each do |performance|

			student_index = students_hash[performance["student_user_id"].to_i]
			activities_index = activities_hash[performance["activity_id"].to_i].to_i

			if students[student_index]["student_performance"][activities_index].nil? || students[student_index]["student_performance"][activities_index]["id"].to_i < performance["id"].to_i
				students[student_index]["student_performance"][activities_index] = performance
			end

		end

		# assign each Activity Goal to the correct Student/Activity
		activity_goals.each do |goal|
			student_index = students_hash[goal["student_user_id"].to_i]
			activities_index = activities_hash[goal["activity_id"].to_i]
    	goal["goal_met"] = ActivityGoal.goal_met(goal["id"])
			students[student_index]["activity_goals"][activities_index] = goal
		end

		# set proficient counts
		proficient_counts.each do |student|
			student_index = students_hash[student["student_user_id"].to_i]
			students[student_index]["proficient_count"] = student["proficient_count"].to_i
		end

		# count activities denominator and calculate mastery % for each student
		students.each do |student|

			mastery_denominator = 0
			activities.each_with_index do |activity, index|
				if ((!activity["due_date"].nil? && activity["due_date"] < Time.now) || 
					(!student["student_performance"][index].nil? && !student["student_performance"][index]["performance_pretty"].nil?))
					mastery_denominator += 1
				end
				student["mastery_denominator"] = mastery_denominator
				student["mastery_percentage"] = student["proficient_count"].to_f/student["mastery_denominator"].to_f
			end

		end

		render json: {status: "success", students_with_performance: students, activities: activities, classroom: classroom}

	end

	# Save student performances for an entire classroom
	# Expects the following parameters:
	# => classroom_id: Integer
	# => due_date: Array of due dates for activities
	# => studentPerformance: two-dimensional Array of Student Performances indexed by Classroom Activity Pairing ID first, and Student User ID second
	def save_student_performances
		
		# Get the classroom from the passed parameter
		@classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]}).first

		# Create and empty array to store and errors on saving
		errors = Array.new

		# Save all due dates that were passed
		due_date_hash = params[:due_date]
		due_date_hash.each do |cap_id, date|
			
			cap = ClassroomActivityPairing.where(id: cap_id).first
			cap.due_date = date
			
			if(!cap.save)
				errors.push(cap.errors)
			end

		end

		# Iterate though each Student Performance passed and create/update/delete as necessary
		student_performance_hash = params[:studentPerformance]

		student_performance_hash.each do |cap_id, student_activity_performances|

			# Get the Classroom Activity Pairing and Activity
			cap = ClassroomActivityPairing.where(id: cap_id).first
			activity = cap.activity

			# Iterate through each student
			student_activity_performances.each do |student_user_id, performance| 
				
				# If the Student has existing Student Performances, retrieve the most recent
				stored_performance = StudentPerformance.where({student_user_id: student_user_id, classroom_activity_pairing_id: cap.id})
					.order("created_at DESC")
					.first

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

					if(stored_performance.nil? && (performance.eql?('true') || performance.eql?('false'))	)
						newStudentPerformance = StudentPerformance.new({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id, completed_performance: performance, performance_date: Time.now})
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

		student_performance = StudentPerformance.where(id: params[:student_performance_id]).includes(:activity_level).first

		if student_performance 
			
			classroom = Classroom.joins(:classroom_activity_pairings).where("classroom_activity_pairings.id = ?", student_performance.classroom_activity_pairing_id).where(teacher_user_id: @current_teacher_user.id).first

			if classroom

				student = StudentUser.where(id: student_performance.student_user_id)
					.select("display_name").first

				activity = Activity.joins(:classroom_activity_pairings).where("classroom_activity_pairings.id = ?", student_performance.classroom_activity_pairing_id).first

				
				render json: {status: "success", activity: activity, student: student, student_performance: student_performance.as_json}

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

	def export_data
		
		tag_ids = params[:tag_ids] && !params[:tag_ids].eql?("[]") ? JSON.parse(params[:tag_ids]) : nil

		classroom = Classroom.where({teacher_user_id: @current_teacher_user.id, id: params[:classroom_id]})
			.first
		
		activities = Activity.activities_with_pairings(classroom.id, params[:search_term], tag_ids, true, false)
		
		performance_array = StudentPerformance.student_performances_with_verification(classroom.id, params[:search_term], tag_ids, nil, true, false)

		proficient_counts = StudentPerformance.student_performance_proficiencies(classroom.id, params[:search_term], tag_ids, nil, true, false)

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

		# calculate mastery % for each student and add activities denominator counts 
		students.each do |student|
			activities_count = 0
			activities.each_with_index do |activity, index|
				if (!activity["due_date"].nil? && activity["due_date"] < Time.now) || !student["student_performance"][index].nil?
					activities_count += 1
				end
			end
			student["activities_count"] = activities_count
			student["mastery"] = ((student["proficient_count"].to_f/student["activities_count"].to_f)*100).round(0).to_s + "%"
		end


		csv_string = CSV.generate do |csv|

			# Due Dates Row
			row = ["", "", "Due Date:"]
			activities.each do |activity|
				row.push(activity["due_date"])
			end
			csv << row

			# Activity Name Row
			row = ["Student Local ID*",  "Students", "% At Mastery"]
			activities.each do |activity|
				row.push(activity["name"])
			end
			csv << row

			# Each student's performances
			students.each do |student|
				row = [student["local_id"], student["display_name"], student["mastery"]]
				student["student_performance"].each do |performance|
					row.push(!performance.nil? ? performance["performance_pretty"] : "")
				end
				csv << row
			end

			csv << ["*Students can set their Local ID in their \"Settings\""]

		end


		# respond_to do |format|
      # format.csv do 
      	headers['Content-Disposition'] = "attachment; filename=\"data_export\""
      	headers['Content-Type'] ||= 'text/csv'
      	send_data csv_string
      # end
    # end

	end

	# 
	def save_reflection

		# find the Activity Goal if it exists, if it doesn't, create a new one with the passed parameters
    activity_goal = ActivityGoal.where({student_user_id: params[:activity_goal][:student_user_id], classroom_activity_pairing_id: params[:activity_goal][:classroom_activity_pairing_id]}).first 
   
    # If an Activity Goal Reflection was passed, create a new Activity Goal Reflection and save it
    activity_goal_reflection = nil
    reflection_save = !params[:reflection] || params[:reflection].strip.empty?
    if !reflection_save
      activity_goal_reflection = ActivityGoalReflection.new({activity_goal_id: activity_goal.id, student_user_id: nil, teacher_user_id: @current_teacher_user.id, reflection: params[:reflection], reflection_date: Time.now})
      reflection_save = activity_goal_reflection.save
    end

    # Render the appropriate JSON, based on whether the Activity Goal and the Activity Goal Reflection were successfully saved
    if reflection_save

      render json: {status: "success", activity_goal: activity_goal, activity_goal_reflection: activity_goal_reflection}

    else
      
      activity_goal_reflection.errors.each do |error|
        puts "#{error}"
      end

      render json: {status: "error", activity_goal: activity_goal, activity_goal_reflection: activity_goal_reflection}
    end

	end

	# Save a submitted student performance
  # Expects the following parameters:
  # student_performance
  # => classroom_activity_pairing_id
  # => scored_performance
  # => completed_performance
  # => performance_date
  # => notes
  # => student_user_id
	def save_student_performance

		# check to make sure the student_user_id passed is an actual student of the teacher
		classroom_ids = @current_teacher_user.classrooms.pluck(:id)
		student = StudentUser.where(id: params[:student_user_id]).first
		student_valid = !student.nil? && !ClassroomStudentUser.where({student_user_id: student.id, classroom_id: classroom_ids}).first.nil?
		if !student_valid
      render json: {status: "error", error: "invalid-student-user-id"}
      return
		end

		# check to make sure the classroom_activity_paiaring_id matched one of the teacher's activities
		cap = ClassroomActivityPairing.where(id: params[:classroom_activity_pairing_id]).first
		cap_valid = !cap.nil? && cap.classroom.teacher_user_id.eql?(@current_teacher_user.id)
		if !cap_valid
      render json: {status: "error", error: "invalid-classroom-activity-pairing-id"}
      return
		end

		@student_performance = StudentPerformance.new(params.require(:student_performance).permit(:classroom_activity_pairing_id, :scored_performance, :completed_performance, :performance_date, :activity_level_id, :notes, :student_user_id))    
    @student_performance.student_user_id = params[:student_user_id]

    if(@student_performance.save)

      render json: {status: "success"}

    else
    
      render json: {status: "error", student_performance_errors: @student_performance.errors}

    end
	end

	# Save all submitted student performances
  # Expects the following parameters:
  # student_performances: an Array where each item has the following fields
  # => id (student_performance_id)
  # => scored_performance
  # => completed_performance
  # => performance_date
  # classroom_activity_pairing_id: an integer that should match every student performance that is submitted
  # student_user_id
  def save_all_student_performances

    #set param variables
    student_performances = params[:student_performances]
    classroom_activity_pairing_id = params[:classroom_activity_pairing_id].to_i

    # iterate through all submitted performances and make sure they are all valid 
    all_valid = true
    student_performances_ids = Array.new
    student_performances_to_save = Array.new
    errors = Hash.new

    student_performances.each do |id, student_performance_hash|
      student_performance = StudentPerformance.where(id: id).first
      if student_performance && 
          student_performance.classroom_activity_pairing_id.eql?(classroom_activity_pairing_id) &&
          student_performance.student_user_id.eql?(params[:student_user_id].to_i)

        student_performance.scored_performance = student_performance_hash["scored_performance"]
        student_performance.completed_performance = student_performance_hash["completed_performance"]
        student_performance.performance_date = student_performance_hash["performance_date"]
        student_performance.activity_level_id = student_performance_hash["activity_level_id"]
        student_performance.notes = student_performance_hash["notes"]

        if student_performance.valid?
          student_performances_to_save.push(student_performance)
          student_performances_ids.push(student_performance.id)
        else
          errors[student_performance.id] = student_performance.errors
          all_valid = false
        end

      else
        all_valid = false
        if !student_performance
          errors["student_performance_id"] = "invalid student_performance_id submitted"
        else
          errors["classroom_activity_pairing_id"] = "classroom_activity_pairing_id does not match student performances submitted"
        end
      end

    end

    # if all the submitted performacnes are valid save them
    if all_valid
      student_performances_to_save.each do |student_performance|
        student_performance.save
      end

      # identify performances that were not passed and delete them
      student_performances_to_delete = StudentPerformance.where({classroom_activity_pairing_id: classroom_activity_pairing_id, student_user_id: params[:student_user_id]})
        .where("id not in (?)", student_performances_ids)
      student_performances_to_delete.each do |student_performance|
        student_performance.destroy
      end

      render json: {status: "success"}

    else

      render json: {status: "error", errors: errors}


    end

    
  end

	#################################################################################
	#
	# Activities App Methods
	#
	#################################################################################

	# Return a JSON array of tags the teacher has created
	def activities_tags
		tags = ActivityTag.tags_for_teacher(@current_teacher_user.id)

		render json: {status: "success" , tags: tags}
	end


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


	# Given an Activity ID, returns a JSON object representing the Activity.  
	# Return JSON object also includes 
	# => Classroom
	# => Classroom Activivty Pairing (use to indicated if activity is assigned to which classrooms)
	# => Activity Tag data
	# => Activity Levels data
	#
	# If an invalid activity ID is passed, then a blank activity is returned
	def activity

		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:activity_id]}).first
		
		if(!@activity.nil?)
			
			# get Hash representing Activity
			activity_hash = @activity.as_json
			
			# get Activity Tags for associated Activity
			activity_hash["tags"] = @activity.activity_tags.to_a.map(&:serializable_hash)

			# get Activity Levels for associated Activity
			activity_hash["levels"] = @activity.activity_levels.to_a.map(&:serializable_hash)

		else

			activity_hash = Activity.new.serializable_hash
			activity_hash["tags"] = Array.new
			activity_hash["levels"] = Array.new


		end

		# get all Classrooms and respective IDs
		classrooms = Classroom.where(teacher_user_id: @current_teacher_user.id).as_json
		classroom_ids = Classroom.where(teacher_user_id: @current_teacher_user.id).pluck(:id)
		
		# get all Classroom Activity pairings
		pairings_hash = ClassroomActivityPairing.where("classroom_id" => classroom_ids)
			.where("activity_id" => activity_hash["id"]).as_json

		# create a lookup Hash to get for the Classroom ID
		classroom_indices = Hash.new
		classrooms.each_with_index do |classroom, index|
			classroom_indices[classroom["id"]] = index
		end

		# Use the lookup Hash to associate each Classroom Activity Pairing to the matching Classroom
		pairings_hash.each do |pairing|
			index = classroom_indices[pairing["classroom_id"]]
			classrooms[index]["classroom_activity_pairing"] = pairing
		end

		# Set the Classrooms key in the Activity Hash
		activity_hash["classrooms"] = classrooms

		# get all the tags for the user
		all_tags = ActivityTag.tags_for_teacher(@current_teacher_user.id)


		render json: {status: "success", activity: activity_hash, activity_tags: all_tags}

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

				# delete the verifications
				verifications = StudentPerformanceVerification.where(classroom_activity_pairing_id: @classroom_activity_pairing.id)
				verifications.each do |verification|
					verification.destroy
				end

				# delete the student performances
				student_performances = StudentPerformance.where(classroom_activity_pairing_id: @classroom_activity_pairing.id)
				student_performances.each do |performance|
					performance.destroy
				end

				# delete re-order all the activities
				other_classroom_activity_pairings = ClassroomActivityPairing.where(classroom_id: @classroom_activity_pairing.classroom_id).where('id <> ?', @classroom_activity_pairing.id).order('sort_order ASC')
				other_classroom_activity_pairings.each_with_index do |cap, index|
					cap.sort_order = index
					cap.save
				end

				# delete the pairing
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
	# => tag_ids, name
	# if a classroom_id is passed, each activity will also have a field for classroom_activity_pairing. This field will be:
	# => nil if this activity hasn't been assigned to the specified Classroom
	# => an object representing the Classroom Activity Pairing
	def teacher_activities_and_tags

		tag_ids = params[:tag_ids] && !params[:tag_ids].eql?("[]") ? JSON.parse(params[:tag_ids]) : nil

		if(params[:search_term].nil? && tag_ids.nil?)
			
			activities = Activity.where({teacher_user_id: @current_teacher_user.id}).as_json

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.pluck(:id).as_json

		elsif tag_ids

			activities = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("activity_tags.id in (?)", tag_ids)
				.distinct
				.as_json

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("activity_tags.id in (?)", tag_ids)
				.distinct
				.pluck(:id)
				.as_json

		elsif params[:search_term]
			
			activities = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("lower(activity_tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?", "%#{params[:search_term].downcase}%", "%#{params[:search_term].downcase}%", "%#{params[:search_term].downcase}%")
				.distinct
				.as_json			

			activity_ids = Activity.joins(:activity_tags)
				.where({teacher_user_id: @current_teacher_user.id})
				.where("lower(activity_tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?", "%#{params[:search_term].downcase}%", "%#{params[:search_term].downcase}%", "%#{params[:search_term].downcase}%")				
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
			activity["classroom_activity_pairing"] = nil
		end

		tags.each do |tag|
			
			index = activities_indices[tag["activity_id"]]			
			activities[index]["tags"].push(tag)
		end

		if params[:classroom_id]
			caps = ClassroomActivityPairing.where(classroom_id: params[:classroom_id]).as_json
			caps.each do |cap|
				index = activities_indices[cap["activity_id"]]
				activities[index]["classroom_activity_pairing"] = cap
			end
		end

		render json: {status: "success", activities: activities}

	end

	# creates a new Activity with Activity Tags and Activity Levels using the parameters passed.  The following paramteres are expected:
	# activity
	# => name
	# => description
	# => instructions
	# => activity_type
	# => min_score
	# => max_score
	# => benchmark1_score
	# => benchmark2_score
	# => link
	# tags
	# levels
	def save_new_activity

		@activity = Activity.new(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score, :link))
		@activity.teacher_user_id = @current_teacher_user.id

		tag_errors = Array.new
		pairing_errors = Array.new
		level_errors = Array.new

		if(@activity.save)

			#save the tags
			tags = params[:tags] ||  {} 
			# params[:tags] = params[:tags].nil? ? {} : params[:tags]
			tags.each do |id, value| 

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

			#save the levels
			activity_levels = params[:activity_levels] ||  {} 
			activity_levels.each do |id, hash| 

				# check if the level exists (and matches the activity id)
				level = ActivityLevel.where({name: hash["name"], activity_id: @activity.id}).first_or_initialize({name: hash["name"], abbreviation: hash["abbreviation"], activity_id: @activity.id})

				if(!level.save)
					level_errors.push(level.errors)
				end

			end

			activity_hash = @activity.serializable_hash
			activity_hash["tags"] = @activity.activity_tags.to_a.map(&:serializable_hash)
			activity_hash["levels"] = @activity.activity_levels.to_a.map(&:serializable_hash)

			render json: {status: "success", activity: activity_hash, tag_errors: tag_errors, pairing_errors: pairing_errors, level_errors: level_errors}
		else

			render json: {status: "error", errors: @activity.errors}

		end
	end


	
	# updates a new Activity with Activity Tags and Activity Levels using the parameters passed.  The following paramteres are expected:
	# activity
	# => name
	# => description
	# => instructions
	# => activity_type
	# => min_score
	# => max_score
	# => benchmark1_score
	# => benchmark2_score
	# => link
	# tags
	# levels
	def update_activity

		@activity = Activity.where({teacher_user_id: @current_teacher_user.id, id: params[:id]}).first

		if !@activity.nil?
			@activity.update(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score, :link))

			if(@activity.valid?)

				tag_errors = Array.new
				pairing_errors = Array.new
				level_errors = Array.new

				# go through all the submitted tags and add/delete as necessary				
				# set param variables
				tags = params[:tags] ||  {} 

				all_tags_valid = true
				all_tag_pairings_valid = true
				tags_to_save = Array.new
				tag_pairings_to_save = Array.new
				tag_errors = Hash.new
				tag_pairing_errors = Hash.new

				tags.each do |id, value| 

					#check if the tag exists, if it doesn't create it
					tag = ActivityTag.where({name: value}).first_or_initialize({name: value})
					if(tag.save)
						tags_to_save.push(tag)
					else
						all_tags_valid = false
						tag_errors[id] = tag.errors
					end

					#create a new activity tag pair if it doesn't exist
					atp = ActivityTagPairing.where({activity_id: @activity.id, activity_tag_id: tag.id}).first_or_initialize					
					if atp.valid?
						tag_pairings_to_save.push(atp) 
					else
						all_tag_pairings_valid = false
						tag_pairing_errors[id] = atp.errors
					end

				end

				# set param variables
				activity_levels =	params[:activity_levels] || {} 

				all_levels_valid = true
				levels_to_save = Array.new
				level_errors = Hash.new
				new_activity_levels = {}

				activity_levels.each do |id, hash| 

					# check if it is a new activity
					if id.include?("new")
						
						# check if the level exists (and matches the activity id)
						level = ActivityLevel.where({name: hash["name"], activity_id: @activity.id}).first_or_initialize({name: hash["name"], abbreviation: hash["abbreviation"], activity_id: @activity.id})
						
					else
					# check if the level exists (and matches the activity id)
						level = ActivityLevel.where({id: id, activity_id: @activity.id}).first

						# update the name
						level.name = hash["name"]
						level.abbreviation = hash["abbreviation"]		
					end

					# check to make sure it is valid
					if(level.valid?)
						levels_to_save.push(level)
					else
						all_levels_valid = false
						level_errors[id] = level.errors
					end
					
				end

				# if all the changes to levels are valid, save them all
				if all_levels_valid && all_tags_valid && all_tag_pairings_valid

					# save activity, tags, pairing, and levels
					@activity.save

					tags_to_save.each do |tag|
						tag.save
					end

					tag_pairings_to_save.each do |atp|
						atp.save
					end

					levels_to_save.each do |level|
						if(level.id.nil?)
							level.save
							new_activity_levels[level.id] = level
						else
							level.save
						end
					end

					# delete all levels from the database if they aren't in the submitted list
					@activity.activity_levels.each do |existing_level|
						if !activity_levels.has_key?(existing_level.id.to_s) && !new_activity_levels.has_key?(existing_level.id)
							puts "destroying level"
							existing_level.destroy
						end
					end

					#delete all tag pairings from the database if they aren't in the submitted list
					@activity.activity_tag_pairings.each do |existing_atp|
						if !tags.has_value?(existing_atp.activity_tag.name)
							existing_atp.destroy
						end
					end

					# prepare the activity hash to return
					activity_hash = @activity.as_json

					render json: {status: "success", activity: activity_hash}

				else

					render json: {status: "error", message: "error-with-tag-pairing-or-level", level_errors: level_errors, tag_errors: tag_errors, tag_pairing_errors: tag_pairing_errors}
				end
				

				
				
			else				

				@classrooms = @current_teacher_user.classrooms	
				render json: {status: "error", message: "error-saving-activity", errors: @activity.errors}

			end

		else

			render json: {status: "error", message: "invalid-activity"}

		end
	end

	# Returns a json object with following fields:
	# => status of the request
	# => field representing all of the teacher's classrooms
	# => field representing the Activity of the specified activity_id
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

	# Given an Classroom ID (classroom_id) and a set of Activity IDs, create/deletes Classroom Activity Pairings appropriately
	# => if a passed Activity ID doesn't not have a corresponding Classroom Activity Pairing, a new one is create)
	# => if a Classroom Activity Pairing exists, but the corresponding Activity ID is not passed, then the Clasroom Activity Pairing is deleted
	def save_activity_assignments
		
		# Bad Classroom id passed
		if !params[:classroom_id] || Classroom.where(id: params[:classroom_id]).where(teacher_user_id: @current_teacher_user.id).first.nil?
			
			render json: {status: "error", message: "classroom does not exist"}

		# Good Classroom id passed
		else

			# Create an array to store any errors
			errors = Array.new

			# Get Classroom Activity Pairings 
			caps = ClassroomActivityPairing.where(classroom_id: params[:classroom_id])

			# Delete all (Student Performance and Student Performance Verifications include) that did not have a matching Activity ID passed
			caps.each do |cap|

				if !params[:activities].to_h.has_key?(cap.activity_id.to_s)

					puts "Deleting activity: #{cap.activity_id}"

					performances = StudentPerformance.where(classroom_activity_pairing_id: cap.id)
					performances.each do |performance|
						if(!performance.destroy)
							errors.push(performance.errors)
						end
					end

					verfications = StudentPerformanceVerification.where(classroom_activity_pairing_id: cap.id)
					verfications.each do |verification|
						if(!verification.destroy)
							errors.push(verification.errors)
						end
					end

					if(!cap.destroy)
						errors.push(cap.errors)
					end

				end

			end

			# Create Classroom Activity Pairing for any activities that don't have one
			# Update Classroom Activity Pairing fields for all activities passed
			params[:activities].to_h.each do |activity_id, activity_hash|
				
				cap = ClassroomActivityPairing.where(classroom_id: params[:classroom_id]).where(activity_id: activity_id).first
				if cap.nil?
					cap = ClassroomActivityPairing.new({classroom_id: params[:classroom_id], activity_id: activity_id, sort_order: ClassroomActivityPairing.max_sort_order(params[:classroom_id]) + 1})
					if(!cap.save)
						errors.push(cap.errors)
					end
				end

				# Update the sort_order if the activity is being archived/unarchived
				if !cap.archived && activity_hash["archived"]
					cap.sort_order = -1
					if(!cap.save)
						errors.push(cap.errors)
					end
				elsif cap.archived && !activity_hash["archived"]
					cap.sort_order = ClassroomActivityPairing.max_sort_order(params[:classroom_id]) + 1
					if(!cap.save)
						errors.push(cap.errors)
					end
				end

				if !cap.update_attributes({due_date: activity_hash["due_date"], hidden: activity_hash["hidden"] || false, archived: activity_hash["archived"] || false})
					errors.push(cap.errors)
				end

			end

			if errors.empty?
				render json: {status: "success"}
			else
				puts errors
				render json: {status: "error", errors: errors}
			end

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

	# Sets the student_user_id session variable, if the the passed student_user_id and classroom_id are valid for the logged in teacher
	# Expects the following parameters:
	# => student_user_id
	# => classroom_id
	def become_student
		classroom_ids = @current_teacher_user.classrooms.pluck(:id)
		if !ClassroomStudentUser.where({student_user_id: params[:student_user_id], classroom_id: classroom_ids}).first.nil?
			session[:student_user_id] = params[:student_user_id]
			render json: {status: "success"}
		else
			render json: {status: "error", error: "invalid-student-user-id-or-classroom-id"}
		end
	end

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


	# Returns JSON object representing a student for a classroom
	# Expects following parameters:
	# => classroom_id
	# => student_user_id
	def student

		if(params[:student_user_id].eql?('null') || params[:classroom_id].eql?('null') )
			render json: {status: "error", error: "invalid-student-user-or-classroom"}
		else
			student = StudentUser.joins(:classrooms)
				.joins("inner join teacher_users t on classrooms.teacher_user_id = t.id")
				.where("t.id = ?", @current_teacher_user.id)
				.where("classrooms.id = ?", params[:classroom_id])
				.where("student_users.id = ?" , params[:student_user_id])
				.first

			if(!student.nil?)
				student = student.as_json
				student.delete("salt")
		    student.delete("password_digest")
		    student.delete("oauth_expires_at")
		    student.delete("oauth_token")
		    student.delete("updated_at")
		    student.delete("create_at")

				render json: {status: "success", student: student}
			
			else

				render json: {status: "error", error: "invalid-student-user-or-classroom"}

			end
		end
		
		
	end

	# returns a json object with the following fields:
	# => activities
	# 	 the activities includes performance data
	# => student
	# => classroom
	# 
	# expects the following parameters:
	# => student_user_id
	# => classroom_id
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


  # Required parameters: classroom_activity_pairing_id, student_user_id
  # Returns in JSON form
  # => the specified Classroom Activity Pairing
  # => the Activity matching the Classroom Actvity Pairing, 
  # => the Student Performances matching the Classroom Activity Pairing and the specified Student User
  # => the Activity Goal and Reflections matching the Classroom Activity Pairing and the specified Student User
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

        activity_goal = ActivityGoal.where(student_user_id: params[:student_user_id]).where(classroom_activity_pairing_id: classroom_activity_pairing.id).order("id DESC").first.as_json
        if activity_goal
          activity_goal["activity_goal_reflections"] = ActivityGoalReflection.where(activity_goal_id: activity_goal["id"]).as_json
        end

        render json: {status: "success", activity: activity, classroom_activity_pairing: classroom_activity_pairing, performances: performances, activity_goal: activity_goal}

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
