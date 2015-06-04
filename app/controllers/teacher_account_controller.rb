class TeacherAccountController < ApplicationController

	before_action :require_teacher_login
	

	def home
		#TODO: check if the user is properly logged in 
		@classrooms = Classroom.where({teacher_user_id: session[:teacher_user_id]}).to_a
	end

	def require_teacher_login
		@current_teacher_user = (!session[:teacher_user_id].nil? && TeacherUser.exists?(session[:teacher_user_id])) ? TeacherUser.find(session[:teacher_user_id]) : nil
		unless !@current_teacher_user.nil?
			redirect_to '/login'
		end
	end

end
