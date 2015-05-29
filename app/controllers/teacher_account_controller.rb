class TeacherAccountController < ApplicationController

	def home
		@classrooms = Classroom.where({teacher_user_id: session[:user_id]}).to_a
	end

end
