class SessionsController < ApplicationController
  

  def create

  	if request.env["omniauth.params"]['signup'] #signing up
  		user = TeacherUser.from_omniauth_sign_up(env["omniauth.auth"])
  		if user.nil?
  			#TODO: FLASH MESSAGE FOR SIGNING UP?
  			flash[:notice] = 'user exists'
  			redirect_to '/sign_up_error'
  		else
  			session[:user_id] = user.id
  			
		    redirect_to '/' + request.env["omniauth.params"]['redirect_path']
  		end
  	
		elsif  request.env["omniauth.params"]['login'] #signing up
			user = TeacherUser.from_omniauth_log_in(env["omniauth.auth"])
			session[:user_id] = user.id
			redirect_to '/' + request.env["omniauth.params"]['redirect_path']
		else
			#GO TO SOME ERROR PAGE
		end

  end

  def destroy
  	session[:user_id] = nil
    redirect_to root_path
  end
end
