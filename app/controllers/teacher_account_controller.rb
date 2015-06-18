class TeacherAccountController < ApplicationController

	before_action :require_teacher_login
	
	def home
		#TODO: check if the user is properly logged in 
		@classrooms = Classroom.where({teacher_user_id: session[:teacher_user_id]}).to_a
	end	

	

end
