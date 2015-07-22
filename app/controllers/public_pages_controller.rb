class PublicPagesController < ApplicationController

	skip_before_action :require_login

	def home
		if !session[:teacher_user_id].nil?
			redirect_to '/teacher_home'
		elsif !session[:student_user_id].nil?
			redirect_to '/student_home'
		end
			
	end


	def login_post
		@teacher_user = (!params[:user].nil? && !params[:user][:email].nil?) ? TeacherUser.find_by_email(params[:user][:email]) : nil
		if @teacher_user && @teacher_user.provider.nil? && @teacher_user.password_valid?(params[:user][:password])			
			session[:teacher_user_id] = @teacher_user.id			
		end
		puts "teacher user: #{@teacher_user}"

		#set student session variable 
		@student_user = (!params[:user].nil? && !params[:user][:email].nil?) ? StudentUser.find_by_email(params[:user][:email]) : nil
		if @student_user && @student_user.provider.nil? && @student_user.password_valid?(params[:user][:password])
			session[:student_user_id] = @student_user.id			
		end
		puts "student user: #{@student_user}"

		respond_to do |format|
			if session[:teacher_user_id] #successful teacher login				
				
					format.json { render json: {login_response: "success", user_type: "teacher", error: nil} }				

			elsif session[:student_user_id] #successful student login
				
					format.json { render json: {login_response: "success", user_type: "student", error:nil} }

			elsif (@student_user && !@student_user.provider.nil?) || 
				(@teacher_user && @teacher_user.provider.nil?) #post login with google credentials attempted
				
					format.json { render json: {login_response: "fail", user_type: nil, error: "post-login-with-oauth-credentials"} }

			else #catch all for unsuccessful login								
					format.json { render json: {login_response: "fail", user_type: nil, error: "invalid-credentials"} }

			end		
		end
			
		
			
		

				
	end

end
