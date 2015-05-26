class SessionsController < ApplicationController
  def create
  	user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
#    puts request.env["omniauth.params"]['redirect_path']
    redirect_to '/' + request.env["omniauth.params"]['redirect_path']
#    redirect_to '/login'
  end

  def destroy
  	session[:user_id] = nil
    redirect_to root_path
  end
end
