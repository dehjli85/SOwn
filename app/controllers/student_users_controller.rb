class StudentUsersController < ApplicationController
	skip_before_filter :require_login, :only => :create
	respond_to :json

	def create

		@student_user = StudentUser.new(params.require(:student_user).permit(:first_name, :last_name, :email, :password))
		@student_user.display_name = @student_user.first_name + ' ' + @student_user.last_name

		if @student_user.save

			render json: {status: "success"}
	
		else	

			render json: {status: "fail", errors: @student_user.errors.to_json}

		end

	end	
	
end
