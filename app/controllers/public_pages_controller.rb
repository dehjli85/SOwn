class PublicPagesController < ApplicationController

	skip_before_action :require_login

	def home
		if !session[:teacher_user_id].nil?
			redirect_to '/teacher_home'
		elsif !session[:student_user_id].nil?
			redirect_to '/student_home'
		end
			
	end

	def sign_up_teacher
		@teacher_user ||= TeacherUser.new
	end

	def sign_up_student
		@student_user ||= StudentUser.new
	end

	def sign_up_error
		flash[:error] ||= 'unexpected'

	end

	def login
		
	end

	def login_post

		#set teacher session variable 
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

		if session[:teacher_user_id] #successful teacher login

			flash[:error] = nil
			redirect_to('/teacher_home')				

		elsif session[:student_user_id] #successful student login

			flash[:error] = nil
			redirect_to('/student_home')				

		elsif (@student_user && !@student_user.provider.nil?) || 
			(@teacher_user && @teacher_user.provider.nil?) #post login with google credentials attempted

			reset_session
			flash[:error] = 'post-login-with-oauth-credentials'					
			render 'login'

		else #catch all for unsuccessful login

			reset_session
			#puts "account exists, but invalid password"
			flash[:error] = "invalid-credentials"
			render "login"

		end		
			
		

				
	end

end
