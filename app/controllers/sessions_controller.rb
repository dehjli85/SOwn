class SessionsController < ApplicationController
  skip_before_action :require_teacher_login

  def create

  	if request.env["omniauth.params"]['signup'] #signing up
      if request.env["omniauth.params"]['type'].eql?('teacher')
        user = TeacherUser.from_omniauth_sign_up(env["omniauth.auth"])
        if user.nil?
          #TODO: FLASH MESSAGE FOR SIGNING UP?
          flash[:notice] = 'user exists'
          redirect_to '/sign_up_error'
        else
          session[:teacher_user_id] = user.id
          
          redirect_to '/' + request.env["omniauth.params"]['redirect_path']
        end
      elsif request.env["omniauth.params"]['type'].eql?('student')
        user = StudentUser.from_omniauth_sign_up(env["omniauth.auth"])
        if user.nil?
          #TODO: FLASH MESSAGE FOR SIGNING UP?
          flash[:notice] = 'user exists'
          redirect_to '/sign_up_error'
        else
          session[:student_user_id] = user.id          
          redirect_to '/' + request.env["omniauth.params"]['redirect_path']
        end
      end  	
		elsif  request.env["omniauth.params"]['login'] #signing up
      user = StudentUser.from_omniauth_log_in(env["omniauth.auth"])
      if user.nil?
  			user = TeacherUser.from_omniauth_log_in(env["omniauth.auth"])
        redirect_path = '/teacher_home'
        session[:teacher_user_id] = user.id
      else
        redirect_path = '/student_home'
        session[:student_user_id] = user.id
      end
			
			redirect_to redirect_path
		else
			#GO TO SOME ERROR PAGE
		end

  end

  def destroy
  	session[:teacher_user_id] = nil
    session[:student_user_id] = nil
    redirect_to root_path
  end
end
