class SessionsController < ApplicationController
  skip_before_action :require_login

  def create

  	if request.env["omniauth.params"]['signup'] #signing up
      if request.env["omniauth.params"]['type'].eql?('teacher')
        puts "Trying to sign up as a teacher"
        user = TeacherUser.from_omniauth_sign_up(env["omniauth.auth"])
        if !user.save
          
          #display error for logging
          user.errors.each do |k,v|
            puts "key:#{k}, message:#{v}"
          end

          if user.errors.has_key?(:email) && user.errors[:email].include?('has already been taken')
            flash[:error] = 'user-exists'
            redirect_to '/sign_up_error'
          else
            flash[:error] = 'unknown-oauth-signup-error'
            redirect_to '/sign_up_error'
          end

        else
          session[:teacher_user_id] = user.id          
          redirect_to '/' + request.env["omniauth.params"]['redirect_path']
        end
      elsif request.env["omniauth.params"]['type'].eql?('student')
        puts "Trying to sign up as a student"
        user = StudentUser.from_omniauth_sign_up(env["omniauth.auth"])        
        if !user.save

          #display error for logging
          user.errors.each do |k,v|
            puts "key:#{k}, message:#{v}"
          end
      
          if user.errors.has_key?(:email) && user.errors[:email].include?('has already been taken')
            flash[:error] = 'user-exists'
            redirect_to '/sign_up_error'
          else
            flash[:error] = 'unknown-oauth-signup-error'
            redirect_to '/sign_up_error'
          end
          
          
          
        else
          session[:student_user_id] = user.id          
          redirect_to '/' + request.env["omniauth.params"]['redirect_path']
        end
      end  	
		elsif  request.env["omniauth.params"]['login'] #logging in
      student_user = StudentUser.from_omniauth_log_in(env["omniauth.auth"])
      puts student_user
      if student_user.nil?        
  			teacher_user = TeacherUser.from_omniauth_log_in(env["omniauth.auth"])
        if !teacher_user.nil?
          redirect_path = '/teacher_home'
          session[:teacher_user_id] = teacher_user.id  
        else
          reset_session
          #puts "account exists, but invalid password"
          flash[:error] = "invalid-google-account"          
          render 'public_pages/login'
        end        
      else
        redirect_path = '/student_home'
        session[:student_user_id] = student_user.id
      end
			
			#redirect_to redirect_path
		else
			
      puts 'Omniauth error'
      flash[:error] = 'omniauth-error'
      flash.keep
      redirect_to '/sign_up_error'
		end

  end

  def destroy
  	session[:teacher_user_id] = nil
    session[:student_user_id] = nil
    redirect_to root_path
  end
end
