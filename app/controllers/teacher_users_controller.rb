class TeacherUsersController < ApplicationController
	skip_before_filter :require_login, :only => :create
	respond_to :json

	def create		

		@teacher_user = TeacherUser.new(params.require(:teacher_user).permit(:first_name, :last_name, :email, :password))
		@teacher_user.display_name = @teacher_user.first_name + ' ' + @teacher_user.last_name
		if @teacher_user.save
			
			render json: {status: "success"}

		else
			
			render json: {status: "fail", errors: @teacher_user.errors.to_json}

		end

	end	

end
