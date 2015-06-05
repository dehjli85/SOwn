class StudentAccountController < ApplicationController

  skip_before_action :require_teacher_login

  def home
  	@student_user = StudentUser.find(session[:student_user_id])

  end

  def join_classroom_confirm
  	@classroom = Classroom.where({classroom_code: params[:classroom_code]}).first

  end

  def join_classroom_confirm_post
  	#confirm the classroom exists
  	if (Classroom.exists?(params[:classroom][:id]))
  		csu = ClassroomsStudentUser.new
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

end
