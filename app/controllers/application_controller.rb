class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  before_action :require_teacher_login

  def current_user
    @current_user ||= TeacherUser.find(session[:user_id]) if session[:user_id]
  end

  def require_teacher_login
		@current_teacher_user = (!session[:teacher_user_id].nil? && TeacherUser.exists?(session[:teacher_user_id])) ? TeacherUser.find(session[:teacher_user_id]) : nil
		unless !@current_teacher_user.nil?
			redirect_to '/login'
		end
	end
end
