class PublicPagesController < ApplicationController

	skip_before_action :require_login

	def index
		
	end
	
	def home

		if(!flash[:notice].eql?('privacy') && !flash[:notice].eql?('terms_of_service') )

			if !session[:teacher_user_id].nil?
				redirect_to '/teacher_home'
			elsif !session[:student_user_id].nil?
				redirect_to '/student_home'
			end
		end
			
	end


	def login_post
		@teacher_user = (!params[:user].nil? && !params[:user][:email].nil?) ? TeacherUser.find_by_email(params[:user][:email].downcase) : nil
		if @teacher_user && @teacher_user.provider.nil? && @teacher_user.password_valid?(params[:user][:password])			
			session[:teacher_user_id] = @teacher_user.id			
		end
		
		#set student session variable 
		@student_user = (!params[:user].nil? && !params[:user][:email].nil?) ? StudentUser.find_by_email(params[:user][:email].downcase) : nil
		if @student_user && @student_user.provider.nil? && @student_user.password_valid?(params[:user][:password])
			session[:student_user_id] = @student_user.id			
		end
		puts "student user: #{@student_user}"

		respond_to do |format|

			if session[:teacher_user_id] && session[:student_user_id]

				user_type = @teacher_user.default_view_student ? "student" : "teacher"
				format.json { render json: {login_response: "success", user_type: user_type, error: nil} }				

			elsif session[:student_user_id] #successful student login
				
				format.json { render json: {login_response: "success", user_type: "student", error:nil} }
					
			elsif session[:teacher_user_id] #successful teacher login				
				
				format.json { render json: {login_response: "success", user_type: "teacher", error: nil} }				

			elsif (@student_user && !@student_user.provider.nil?) || 
				(@teacher_user && !@teacher_user.provider.nil?) #post login with google credentials attempted
				
					format.json { render json: {login_response: "fail", user_type: nil, error: "post-login-with-oauth-credentials"} }

			else #catch all for unsuccessful login								
					format.json { render json: {login_response: "fail", user_type: nil, error: "invalid-credentials"} }

			end		
		end
				
	end

	def google_login_post

		# use id_token to get email from google
		
		ga = GoogleAuth.new		#This is a model we created


		begin
			
			userinfo = ga.get_userinfo_from_id_token(params[:id_token])

			@teacher_user = TeacherUser.where({email: userinfo["email"].downcase}).first
			if @teacher_user && @teacher_user.provider.eql?("google_oauth2")
				session[:teacher_user_id] = @teacher_user.id			
			end

			@student_user = StudentUser.where({email: userinfo["email"].downcase}).first
			if @student_user && @student_user.provider.eql?("google_oauth2")
				session[:student_user_id] = @student_user.id			
			end

			respond_to do |format|
			if session[:teacher_user_id] && session[:student_user_id]

				user_type = @teacher_user.default_view_student ? "student" : "teacher"
				format.json { render json: {login_response: "success", user_type: user_type, error: nil} }				

			elsif session[:student_user_id] #successful student login
				
				format.json { render json: {login_response: "success", user_type: "student", error:nil} }

			elsif session[:teacher_user_id] #successful teacher login				
				
				format.json { render json: {login_response: "success", user_type: "teacher", error: nil} }				
			

			elsif (@student_user && @student_user.provider.nil?) || 
				(@teacher_user && @teacher_user.provider.nil?) #google login with stg credentials attempted
				
					format.json { render json: {login_response: "fail", user_type: nil, error: "post-login-with-stg-credentials"} }

			else #catch all for unsuccessful login								
					format.json { render json: {login_response: "fail", user_type: nil, error: "invalid-credentials"} }

			end		
		end


		rescue => error
			puts error
			puts error.backtrace
			render json: {status: "error", message: "unknown-authentication-error"}	
		end

	end


	def teacher_google_sign_up

		ga = GoogleAuth.new

		begin

			userinfo = ga.get_userinfo_from_id_token(params[:id_token])

			user = TeacherUser.new
			user.provider = "google_oauth2"
	    user.uid = userinfo["uid"]
	    user.email = userinfo["email"].downcase
	    user.first_name = userinfo["first_name"]
	    user.last_name = userinfo["last_name"]
	    user.username = userinfo["email"].downcase
	    user.display_name = userinfo["display_name"]

	    if user.save

	    	session[:teacher_user_id] = user.id

	    	render json: {status: "success", teacher_user: user}

	    else	
    		render json: {status: "error", message: "unable-to-save-user", errors: user.errors}	
	    end

		rescue
			render json: {status: "error", message: "unknown-authentication-error"}	
		end
				
	end

	def student_google_sign_up

		ga = GoogleAuth.new

		begin

			userinfo = ga.get_userinfo_from_id_token(params[:id_token])

			user = StudentUser.new
			user.provider = "google_oauth2"
	    user.uid = userinfo["uid"]
	    user.email = userinfo["email"].downcase
	    user.first_name = userinfo["first_name"]
	    user.last_name = userinfo["last_name"]
	    user.username = userinfo["email"].downcase
	    user.display_name = userinfo["display_name"]

	    if user.save

	    	session[:student_user_id] = user.id

	    	render json: {status: "success", teacher_user: user}

	    else	
	    	render json: {status: "error", message: "unable-to-save-user", errors: user.errors}	
	    end

		rescue
			render json: {status: "error", message: "unknown-authentication-error"}	
		end
				
	end

	def google_auth_callback

		if request.env["omniauth.params"]['signup'] #signing up
      if request.env["omniauth.params"]['type'].eql?('teacher')
        puts "Trying to sign up as a teacher"
        user = TeacherUser.from_omniauth_sign_up(env["omniauth.auth"])
        if !user.save
          
          #display error for logging
          user.errors.each do |k,v|
            puts "key:#{k}, message:#{v}"
          end

          if user.errors.has_key?(:email) && user.errors[:email].include?('has already been taken')
            flash[:error] = 'user-exists'
            redirect_to '/#login'
          else
            flash[:error] = 'unknown-oauth-signup-error'
            redirect_to '/#sign_up_teacher'
          end

        else
          session[:teacher_user_id] = user.id          
          redirect_to '/' + request.env["omniauth.params"]['redirect_path']
        end
      elsif request.env["omniauth.params"]['type'].eql?('student')
        puts "Trying to sign up as a student"
        user = StudentUser.from_omniauth_sign_up(env["omniauth.auth"])        
        if !user.save

          #display error for logging
          user.errors.each do |k,v|
            puts "key:#{k}, message:#{v}"
          end
      
          if user.errors.has_key?(:email) && user.errors[:email].include?('has already been taken')
            flash[:error] = 'user-exists'
            redirect_to '/#login'
          else
            flash[:error] = 'unknown-oauth-signup-error'
            redirect_to '/#sign_up_student'
          end
          
          
          
        else
          session[:student_user_id] = user.id          
          redirect_to '/' + request.env["omniauth.params"]['redirect_path']
        end
      end  	
		elsif  request.env["omniauth.params"]['login'] #logging in
      student_user = StudentUser.from_omniauth_log_in(env["omniauth.auth"])
      puts "student_user: #{student_user}"
      if student_user.nil?        
  			teacher_user = TeacherUser.from_omniauth_log_in(env["omniauth.auth"])
        puts "teacher_user: #{teacher_user}"
        if !teacher_user.nil?
          redirect_path = '/teacher_home'
          session[:teacher_user_id] = teacher_user.id  
        else
          reset_session
          #puts "account exists, but invalid password"
          flash[:error] = "invalid-google-account"          
          render 'public_pages/login'
        end        
      else
        redirect_path = '/student_home'
        session[:student_user_id] = student_user.id
      end
			
			redirect_to redirect_path
		else
			
      puts 'Omniauth error'
      flash[:error] = 'omniauth-error'
      flash.keep
      redirect_to '/sign_up_error'
		end
		
	end

	def teacher_sign_up
		teacher = TeacherUser.new(params.require(:user).permit(:first_name, :last_name, :email, :password))
		teacher.display_name = teacher.first_name + ' ' + teacher.last_name
		teacher.username = teacher.email
		if(teacher.save)
			render json: {status: "success"}
		else
			render json: {status: "error", errors: teacher.errors}
		end

	end

	def student_sign_up
		student = StudentUser.new(params.require(:user).permit(:first_name, :last_name, :email, :password))
		student.display_name = student.first_name +  ' ' + student.last_name
		student.username = student.email
		if(student.save)
			render json: {status: "success"}
		else
			render json: {status: "error", errors: student.errors}
		end		
	end

	def signout

		session[:teacher_user_id] = nil
    session[:student_user_id] = nil
    session[:admin_user_id] = nil
    redirect_to root_path
		
	end

	def signout_json

		session[:teacher_user_id] = nil
    session[:student_user_id] = nil
    session[:admin_user_id] = nil
		render json: {status: "success"}
		
	end

	def privacy
		flash[:notice] = 'privacy'
		redirect_to '/#privacy' 
	end

	def terms_of_service
		flash[:notice] = 'terms_of_service'
		redirect_to '/#terms_of_service'
	end

end
