class StudentAccountController < ApplicationController

  require 'google/api_client/client_secrets'
  require 'google/apis/oauth2_v2'

  before_action :require_student_login_json, except: [:index]

  respond_to :json

  #################################################################################
  #
  # StudentApp Methods
  #
  #################################################################################

  def index
    require_student_login
  end

  def current_student_user
    student = @current_student_user.serializable_hash
    student.delete("salt")
    student.delete("password_digest")
    student.delete("oauth_expires_at")
    student.delete("oauth_token")
    student.delete("provider")
    student.delete("uid")
    student.delete("updated_at")
    student.delete("create_at")

    render json: {status: "success", student: student}

  end

  #################################################################################
  #
  # Classrooms Methods
  #
  #################################################################################

  def classrooms_summary

    classrooms = @current_student_user.classrooms
      
    
    classrooms_hash = classrooms.joins(:teacher_user)
      .select("teacher_users.display_name", "teacher_users.first_name", "teacher_users.last_name", "teacher_users.salutation", "classrooms.id as classroom_id", "classrooms.name")
      .as_json

    classrooms.each_with_index do |classroom, index|
      classrooms_hash[index]["percent_proficient"] = classroom.percent_proficient_activities(@current_student_user.id)*100
    end

    render json: {status: "success", classrooms: classrooms_hash}
    
  end

  def search_classroom_code

    @classroom = Classroom.joins(:teacher_user).where({classroom_code: params[:classroom_code]}).select("classrooms.*", "teacher_users.display_name").first



    if(@classroom)

      classroom_hash = @classroom.serializable_hash
      render json: {status: "success", classroom: classroom_hash}

    else
      render json: {status: "error", message: "invalid-classroom-code"}
    end
    
  end

  def join_classroom

    #confirm the classroom exists
    if Classroom.exists?(params[:classroom_id])

      csu = ClassroomStudentUser.new
      csu.student_user_id = @current_student_user.id
      csu.classroom_id = params[:classroom_id]

      if csu.save
        
        render json: {status: "success"}

      else
        
        render json: {status: "error", message: "failed-to-save-classroom-student-user-pairing"}

      end

    else

      render json: {status: "error", message: "invalid-classroom-id"}

    end

    
  end

  #################################################################################
  #
  # Classroom Methods
  #
  #################################################################################

  def classroom
    classrooms = Classroom.joins(:classroom_student_users).where("student_user_id = ? and classrooms.id = ?", @current_student_user.id, params[:classroom_id])

    if !classrooms.empty?
    
      classroom = classrooms.joins(:teacher_user).select("classrooms.id","teacher_users.display_name", "teacher_users.first_name", "teacher_users.last_name", "teacher_users.salutation", "classrooms.name").first.serializable_hash
      
      render json: {status: "success", classroom: classroom}
    
    else

      render json: {status: "error", message: "invalid-classroom"}

    end

  end

  #return the json object representing the unique tags for the classroom with the specified id for the logged in user
  def classroom_tags

    @classroom = Classroom.joins(:classroom_activity_pairings)
      .joins(:classroom_student_users)
      .where(id: params[:classroom_id])
      .where("classroom_student_users.student_user_id = ?", @current_student_user.id)
      .first

    render json: @classroom.tags(false, false).to_json
    
  end

  def classroom_activities_and_performances
    
    tag_ids = params[:tag_ids] && !params[:tag_ids].eql?("[]") ? JSON.parse(params[:tag_ids]) : nil
    
    classroom = Classroom.joins(:classroom_student_users)
      .where("student_user_id = ? and classrooms.id = ?", @current_student_user.id, params[:classroom_id])
      .first

    if !classroom.nil?

      activities = classroom.activities_and_performances(@current_student_user.id, {search_term: params[:search_term], tag_ids: tag_ids})        

      render json: {status: "success", activities:activities}

    else

      render json: {status: "error", message: "invalid-classroom"}

    end  

  end

  def activity
    
    classroom_activity_pairing = ClassroomActivityPairing.where(id: params[:classroom_activity_pairing_id]).first

    if classroom_activity_pairing

      classroom_student_users = ClassroomStudentUser.where(classroom_id: classroom_activity_pairing.classroom_id).where(student_user_id: @current_student_user.id).first

      if classroom_student_users

        activity = classroom_activity_pairing.activity
        activity_hash = activity.serializable_hash
        activity_hash["levels"] = activity.activity_levels.as_json

        render json: {status: "success", activity: activity, classroom_activity_pairing: classroom_activity_pairing}

      else

      render json: {status: "error", message: "invalid-student-for-classroom-activity-pairing"}

      end

    else

      render json: {status: "error", message: "invalid-classroom-activity-pairing-id"}

    end

  end

  # Required parameters: classroom_activity_pairing_id
  # Returns in JSON form
  # => the specified Classroom Activity Pairing
  # => the Activity matching the Classroom Actvity Pairing, 
  # => the Student Performances matching the Classroom Activity Pairing and the logged in Student User
  # => the Activity Goal and Reflections matching the Classroom Activity Pairing and the logged in Student User
  def activity_and_performances
    
    classroom_activity_pairing = ClassroomActivityPairing.where(id: params[:classroom_activity_pairing_id]).first

    if classroom_activity_pairing

      classroom_student_users = ClassroomStudentUser.where(classroom_id: classroom_activity_pairing.classroom_id).where(student_user_id: @current_student_user.id).first

      if classroom_student_users

        activity = classroom_activity_pairing.activity

        # performances = StudentPerformance.where({classroom_activity_pairing_id: classroom_activity_pairing.id, student_user_id: @current_student_user.id})
        #   .order("created_at ASC")
        #   .as_json

        # performances.each do |performance|
        #   performance["performance_pretty"] = StudentPerformance.performance_pretty_no_active_record(activity.activity_type, performance["scored_performance"], performance["completed_performance"], performance.activity_level ? performance.activity_level.name : nil)
        #   performance["performance_color"] = StudentPerformance.performance_color_no_active_record(activity.activity_type, activity.benchmark1_score, activity.benchmark2_score, activity.min_score, activity.max_score, performance["scored_performance"], performance["completed_performance"])

        # end

        performances = StudentPerformance.where({classroom_activity_pairing_id: classroom_activity_pairing.id, student_user_id: @current_student_user.id}).order("created_at ASC").as_json

        activity_goal = ActivityGoal.where(student_user_id: @current_student_user.id).where(classroom_activity_pairing_id: classroom_activity_pairing.id).order("id DESC").first.as_json
        if activity_goal
          activity_goal["activity_goal_reflections"] = ActivityGoalReflection.where(activity_goal_id: activity_goal["id"])
        end

        

        render json: {status: "success", activity: activity, classroom_activity_pairing: classroom_activity_pairing, performances: performances, activity_goal: activity_goal}

      else

      render json: {status: "error", message: "invalid-student-for-classroom-activity-pairing"}

      end

    else

      render json: {status: "error", message: "invalid-classroom-activity-pairing-id"}

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
  def save_student_performance

    @student_performance = StudentPerformance.new(params.require(:student_performance).permit(:classroom_activity_pairing_id, :scored_performance, :completed_performance, :performance_date, :activity_level_id, :notes))    
    @student_performance.student_user_id = @current_student_user.id

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
  def save_all_student_performances

    #set param variables
    student_performances = params[:student_performances] || {}
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
          student_performance.student_user_id.eql?(@current_student_user.id)

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
      student_performances_to_delete = StudentPerformance.where({classroom_activity_pairing_id: classroom_activity_pairing_id, student_user_id: @current_student_user.id})
      if !student_performances_ids.empty?
        student_performances_to_delete = student_performances_to_delete.where("id not in (?)", student_performances_ids)
      end

      student_performances_to_delete.each do |student_performance|
        student_performance.destroy
      end

      render json: {status: "success"}

    else

      render json: {status: "error", errors: errors}


    end

    
  end

  def save_new_activity_goal

    # find the Activity Goal if it exists, if it doesn't, create a new one with the passed parameters
    activity_goal = ActivityGoal.where({student_user_id: @current_student_user.id, classroom_activity_pairing_id: params[:activity_goal][:classroom_activity_pairing_id]}).first 
    if !activity_goal 
      activity_goal = ActivityGoal.new(params.require(:activity_goal).permit(:score_goal, :goal_date, :classroom_activity_pairing_id))
    else
      activity_goal.update_attributes({score_goal: params[:activity_goal][:score_goal], goal_date: params[:activity_goal][:goal_date], score_goal: params[:activity_goal][:score_goal]})
    end
    

    # set the Student User ID, and save it
    activity_goal.student_user_id = @current_student_user.id
    goal_save = activity_goal.save

    # If an Activity Goal Reflection was passed, create a new Activity Goal Reflection and save it
    activity_goal_reflection = nil
    reflection_save = !params[:reflection] || params[:reflection].strip.empty?
    if !reflection_save
      activity_goal_reflection = ActivityGoalReflection.new({activity_goal_id: activity_goal.id, student_user_id: @current_student_user.id, reflection: params[:reflection], reflection_date: Time.now})
      reflection_save = activity_goal_reflection.save
    end

    # Render the appropriate JSON, based on whether the Activity Goal and the Activity Goal Reflection were successfully saved
    if goal_save && reflection_save
      render json: {status: "success", activity_goal: activity_goal, activity_goal_reflection: activity_goal_reflection}
    else
      if !goal_save
        activity_goal.errors.each do |error|
          puts "#{error}"
        end
      end
      if !reflection_save
        activity_goal_reflection.errors.each do |error|
          puts "#{error}"
        end
      end
      render json: {status: "error", activity_goal: activity_goal, activity_goal_reflection: activity_goal_reflection}
    end

  end

  #################################################################################
  #
  # Settings Methods
  #
  #################################################################################
  def save_settings

    # @current_teacher_user.default_view_student = params[:default_view_student]
    @current_student_user.assign_attributes(params.require(:student_user).permit(:first_name, :last_name, :gender, :local_id, :email))
    @current_student_user.display_name = @current_student_user.first_name + ' ' + @current_student_user.last_name

    if @current_student_user.save

      render json: {status: "success"}

    else

      render json: {status: "error", message: "unable-to-save-settings"}

    end
    
    @current_student_user.local_id = params[:localId]


  end

  def update_password
    
    old_password = params[:oldPassword]
    new_password = params[:newPassword]
    confirm_password = params[:confirmNewPassword]

    # check that it's a sown to grow account and the old password matches
    if !(@current_student_user && @current_student_user.provider.nil? && @current_student_user.password_valid?(old_password))
      
      render json: {status: "error", message: "incorrect-original-password-for-specified-user"}
    
    else
      # if the old password matches, check that the new and confirm are the same and not blank
      if !new_password.eql?(confirm_password)
        render json: {status: "error", message: "new-and-confirm-password-do-not-match"}
      else
        @current_student_user.password = new_password
        if !@current_student_user.save
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
    if !(@current_student_user && !@current_student_user.provider.nil?)
      
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

        @current_student_user.provider = "google_oauth2"
        @current_student_user.uid = user_info.id
        @current_student_user.oauth_token = token["access_token"]
        @current_student_user.oauth_expires_at = Time.now + token["expires_in"]
        @current_student_user.email = user_info.email.downcase
        @current_student_user.first_name = user_info.given_name
        @current_student_user.last_name = user_info.family_name
        @current_student_user.username = user_info.email.downcase
        @current_student_user.display_name = user_info.name

        @current_student_user.password=nil

        if @current_student_user.save
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
        @current_student_user.password = password
        @current_student_user.provider = nil
        @current_student_user.uid = nil
        @current_student_user.oauth_token = nil
        @current_student_user.oauth_expires_at = nil

        if !@current_student_user.save
          render json: {status: "error", message: "unable-to-update-password-for-specified-user"}
        else
          render json: {status: "success"}        
        end
      end


    end
     
  end

end
