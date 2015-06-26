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

	end

	def sign_up_error
		
	end

	def login
		
	end

	def login_post

		#check for teacher first
		@teacher_user = (!params[:user].nil? && !params[:user][:email].nil?) ? TeacherUser.find_by_email(params[:user][:email]) : nil
		puts @teacher_user
		if !@teacher_user.nil? 
			if @teacher_user.password_valid?(params[:user][:password])
				session[:teacher_user_id] = @teacher_user.id
				flash[:error] = nil
				redirect_to('/teacher_home')
			else
				reset_session
				flash[:error] = "Invalid Login Credentials"
				render "login"
			end
		else
			#check student user second
			@student_user = (!params[:user].nil? && !params[:user][:email].nil?) ? StudentUser.find_by_email(params[:user][:email]) : nil
			if(!@student_user.nil?)
				if @student_user.password_valid?(params[:user][:password])
					session[:student_user_id] = @student_user.id
					flash[:error] = nil
					redirect_to('/student_home')				
				else
					reset_session
					flash[:error] = "Invalid Login Credentials"
					render "login"
				end
			else
				reset_session
				flash[:error] = "Invalid Login Credentials"
				render "login"	
			end

			
		end
		
	end


end
