class StudentAccountController < ApplicationController

  skip_before_action :require_teacher_login
  before_action :require_student_login, :current_user

  respond_to :json

  #################################################################################
  #
  # StudentApp Methods
  #
  #################################################################################

  def index
    
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
      .select("teacher_users.display_name", "classrooms.id as classroom_id", "classrooms.name")
      .as_json

    classrooms.each_with_index do |classroom, index|
      classrooms_hash[index]["percent_proficient"] = classroom.percent_proficient_activities_student(@current_student_user.id)*100
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
    
      classroom = classrooms.joins(:teacher_user).select("classrooms.id","teacher_users.display_name", "classrooms.name").first.serializable_hash
      
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

    render json: @classroom.tags(false).to_json
    
  end

  def classroom_activities_and_performances
      
      classroom = Classroom.joins(:classroom_student_users)
        .where("student_user_id = ? and classrooms.id = ?", @current_student_user.id, params[:classroom_id])
        .first

      if !classroom.nil?

        activities = classroom.activities_and_performances(@current_student_user.id, {search_term: params[:search_term], search_tag: params[:tag_id]})        

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

      classroom_student_users = ClassroomStudentUser.where(classroom_id: classroom_activity_pairing.classroom_id).where(student_user_id: @current_student_user.id).first

      if classroom_student_users

        activity = classroom_activity_pairing.activity

        performances = StudentPerformance.where({classroom_activity_pairing_id: classroom_activity_pairing.id, student_user_id: @current_student_user.id}).order("created_at ASC").as_json

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

  def save_student_performance

    @student_performance = StudentPerformance.new(params.require(:student_performance).permit(:classroom_activity_pairing_id, :scored_performance, :completed_performance, :performance_date))    
    @student_performance.student_user_id = @current_student_user.id
    
    puts "student_performance: #{@student_performance}"

    if(@student_performance.save)

      render json: {status: "success"}

    else
    
      render json: {status: "error", student_performance_errors: @student_performance.errors}

    end
    
  end

  #################################################################################
  #
  # Old Methods
  #
  #################################################################################
 

  def home
  	@student_user = StudentUser.find(session[:student_user_id])

  end


  def join_classroom_confirm
  	@classroom = Classroom.where({classroom_code: params[:classroom_code]}).first

  end

  def join_classroom_confirm_post
  	#confirm the classroom exists
  	if (Classroom.exists?(params[:classroom][:id]))
  		csu = ClassroomStudentUser.new
  		csu.student_user_id = session[:student_user_id]
  		csu.classroom_id = params[:classroom][:id]

  		if csu.save
  			redirect_to '/student_home'
  		else
  			flash[:notice] = 'Error joining class'
  			render join_classroom_confirm
  		end
  	else
  		flash[:notice] = 'Class doesn\'t exists'
  		render join_classroom_confirm
  	end
  end

  def view_classroom
    csu = ClassroomsStudentUsers.where({student_user_id: @current_student_user.id, classroom_id: params[:classroom_id]}).first
    @classroom = !csu.nil? && Classroom.exists?(params[:classroom_id]) ? Classroom.find(params[:classroom_id]) : nil
    
    activities_performances = @classroom.get_activities_and_student_performance_data(@current_student_user.id)
    @activities = activities_performances[:activities]
    @performances = activities_performances[:student_performances]
  end



end
