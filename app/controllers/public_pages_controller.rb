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

			if session[:teacher_user_id] && session[:student_user_id]

				user_type = @teacher_user.default_view_student ? "student" : "teacher"
				format.json { render json: {login_response: "success", user_type: user_type, error: nil} }				

			elsif session[:student_user_id] #successful student login
				
				format.json { render json: {login_response: "success", user_type: "student", error:nil} }
					
			elsif session[:teacher_user_id] #successful teacher login				
				
				format.json { render json: {login_response: "success", user_type: "teacher", error: nil} }				

			elsif (@student_user && !@student_user.provider.nil?) || 
				(@teacher_user && @teacher_user.provider.nil?) #post login with google credentials attempted
				
					format.json { render json: {login_response: "fail", user_type: nil, error: "post-login-with-oauth-credentials"} }

			else #catch all for unsuccessful login								
					format.json { render json: {login_response: "fail", user_type: nil, error: "invalid-credentials"} }

			end		
		end
				
	end

	def google_login_post
		ga = GoogleAuth.new		

		begin
			
			authorization = ga.exchange_code(params[:authorization_code])
			user_info = ga.get_user_info(authorization)

			@teacher_user = TeacherUser.where({email: user_info.email}).first
			if @teacher_user && @teacher_user.provider.eql?("google_oauth2")
				session[:teacher_user_id] = @teacher_user.id			
			end

			@student_user = StudentUser.where({email: user_info.email}).first
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


		rescue
			render json: {status: "error", message: "unknown-authentication-error"}	
		end

	end


	def teacher_google_sign_up

		ga = GoogleAuth.new

		begin
			authorization = ga.exchange_code(params[:authorization_code])
			user_info = ga.get_user_info(authorization)

			user = TeacherUser.new
			user.provider = "google_oauth2"
	    user.uid = user_info.id
	    user.oauth_token = authorization.access_token
	    user.oauth_expires_at = Time.at(authorization.expires_at)
	    user.email = user_info.email
	    user.first_name = user_info.given_name
	    user.last_name = user_info.family_name
	    user.username = user_info.email
	    user.display_name = user_info.name

	    if user.save

	    	session[:teacher_user_id] = user.id

	    	render json: {status: "success", teacher_user: user}

	    else	
	    	render json: {status: "error", message: "unable-to-save-teacher", errors: user.errors}	
	    end

		rescue
			render json: {status: "error", message: "unknown-authentication-error"}	
		end
				
	end

	def student_google_sign_up

		ga = GoogleAuth.new

		begin
			authorization = ga.exchange_code(params[:authorization_code])
			user_info = ga.get_user_info(authorization)

			user = StudentUser.new
			user.provider = "google_oauth2"
	    user.uid = user_info.id
	    user.oauth_token = authorization.access_token
	    user.oauth_expires_at = Time.at(authorization.expires_at)
	    user.email = user_info.email
	    user.first_name = user_info.given_name
	    user.last_name = user_info.family_name
	    user.username = user_info.email
	    user.display_name = user_info.name

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
		if(teacher.save)
			render json: {status: "success"}
		else
			render json: {status: "error", errors: teacher.errors}
		end

	end

	def student_sign_up
		student = StudentUser.new(params.require(:user).permit(:first_name, :last_name, :email, :password))
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

end
