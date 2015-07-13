class TeacherUsersController < ApplicationController
	skip_before_filter :require_login, :only => :create
	def create
		@teacher_user = TeacherUser.new(params.require(:teacher_user).permit(:first_name, :last_name, :email, :password))
		@teacher_user.display_name = @teacher_user.first_name + ' ' + @teacher_user.last_name
		if @teacher_user.save
			flash[:notice] = 'New account successfully create.  Please Login.'
			redirect_to '/login'
		else
			render 'public_pages/sign_up_teacher'
		end
	end	



end
