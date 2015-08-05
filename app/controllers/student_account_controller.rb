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

      csu = ClassroomsStudentUsers.new
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
    classrooms = Classroom.joins(:classrooms_student_users).where("student_user_id = ? and classrooms.id = ?", @current_student_user.id, params[:classroom_id])

    if !classrooms.empty?
    
      classroom = classrooms.joins(:teacher_user).select("classrooms.id","teacher_users.display_name", "classrooms.name").first.serializable_hash
      
      render json: {status: "success", classroom: classroom}
    
    else

      render json: {status: "error", message: "invalid-classroom"}

    end

  end

  def classroom_activities_and_performances
      
      classrooms = Classroom.joins(:classrooms_student_users).where("student_user_id = ? and classrooms.id = ?", @current_student_user.id, params[:classroom_id])

      if !classrooms.empty?

        classroom = classrooms.first

        cap_ids = classroom.classroom_activity_pairings.pluck(:id)

        activities = Activity.joins("inner join classroom_activity_pairings cap on cap.activity_id = activities.id")
          .joins("inner join classrooms c on c.id = cap.classroom_id")
          .where("c.id = ?", classroom.id)
          .select("activities.*, cap.id as classroom_activity_pairing_id")
          .as_json
        activity_indices = Hash.new

        # activities = Activity.joins("inner join classroom_activity_pairings cap on cap.activity_id = activities.id").joins("inner join classrooms c on c.id = cap.classroom_id").where("c.id = ?", classroom.id).select("activities.*, cap.id as classroom_activity_pairing_id").as_json

        activities.each_with_index do |activity, index|
          activity_indices[activity["id"]] = index
          activities[index]["student_performances"] = Array.new
        end

        performances_array = StudentPerformance.joins(:classroom_activity_pairing)
          .joins("left join student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id")
          .where(classroom_activity_pairing_id: cap_ids)
          .where(student_user_id: @current_student_user.id)
          .order("created_at DESC")
          .select("student_performances.*, classroom_activity_pairings.activity_id", "spv.id is not null as requires_verification")
          .as_json

          # performances_array = StudentPerformance.joins(:classroom_activity_pairing).joins("left join student_performance_verifications spv on classroom_activity_pairings.id = spv.id").where(classroom_activity_pairing_id: cap_ids).where(student_user_id: @current_student_user.id).order("created_at DESC").select("student_performances.*, classroom_activity_pairings.activity_id", "spv.id is not null as requires_verification").as_json

        performances_array.each do |performance|

          index = activity_indices[performance["activity_id"]]
          performance["performance_pretty"] = StudentPerformance.performance_pretty_no_active_record(activities[index]["activity_type"], performance["scored_performance"], performance["completed_performance"])
          performance["performance_color"] = StudentPerformance.performance_color_no_active_record(activities[index]["activity_type"], activities[index]["benchmark1_score"], activities[index]["benchmark2_score"], activities[index]["min_score"], activities[index]["max_score"], performance["scored_performance"], performance["completed_performance"])
          activities[index]["student_performances"].push(performance)
        end

        render json: {status: "success", activities:activities}

      else

        render json: {status: "error", message: "invalid-classroom"}

      end  

  end

  def activity
    
    classroom_activity_pairing = ClassroomActivityPairing.where(id: params[:classroom_activity_pairing_id]).first

    if classroom_activity_pairing

      classrooms_student_users = ClassroomsStudentUsers.where(classroom_id: classroom_activity_pairing.classroom_id).where(student_user_id: @current_student_user.id).first

      if classrooms_student_users

        activity = classroom_activity_pairing.activity

        render json: {status: "success", activity: activity, classroom_activity_pairing: classroom_activity_pairing}

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
  		csu = ClassroomsStudentUsers.new
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
