class StudentUsersController < ApplicationController
	skip_before_filter :require_login, :only => :create
	def create
		@student_user = StudentUser.new(params.require(:student_user).permit(:first_name, :last_name, :email, :password))
		@student_user.display_name = @student_user.first_name + ' ' + @student_user.last_name
		if @student_user.save
			flash[:notice] = 'New account successfully create.  Please Login.'
			redirect_to '/login'
		else
			render 'public_pages/sign_up_student'
		end
	end	



end
