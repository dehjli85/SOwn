class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  before_action :require_login

  def current_user
    @current_teacher_user ||= TeacherUser.find(session[:teacher_user_id]) if session[:teacher_user_id]
    @current_student_user ||= StudentUser.find(session[:student_user_id]) if session[:student_user_id]
  end
 

  def require_login
    @current_teacher_user = (!session[:teacher_user_id].nil? && TeacherUser.exists?(session[:teacher_user_id])) ? TeacherUser.find(session[:teacher_user_id]) : nil
    @current_student_user = (!session[:student_user_id].nil? && StudentUser.exists?(session[:student_user_id])) ? StudentUser.find(session[:student_user_id]) : nil
    unless !@current_teacher_user.nil? || !@current_student_user.nil?
      redirect_to '/#login'
    end
  end

  def require_teacher_login
    @current_teacher_user = (!session[:teacher_user_id].nil? && TeacherUser.exists?(session[:teacher_user_id])) ? TeacherUser.find(session[:teacher_user_id]) : nil
    unless !@current_teacher_user.nil?
      redirect_to '/#login'
    end
  end

  def require_student_login
    @current_student_user = (!session[:student_user_id].nil? && StudentUser.exists?(session[:student_user_id])) ? StudentUser.find(session[:student_user_id]) : nil
    unless !@current_student_user.nil?
      redirect_to '/#login'
    end
  end


end
