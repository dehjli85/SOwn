class StudentAccountController < ApplicationController

  skip_before_action :require_teacher_login
  before_action :require_student_login

  

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
    
    activities_performance = @classroom.get_activities_and_student_performance_data(@current_student_user.id)
    @activities = activities_performance[:activities]
    @performance = activities_performance[:student_performance]
  end



end
