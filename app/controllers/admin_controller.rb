class AdminController < ApplicationController

	skip_before_action :require_login

	before_filter :verify_admin_login, :except => [:home, :google_login_post, :logged_in]

	def verify_admin_login
		if !session[:admin_user_id] 
			render json: {status: "error", message: "invalid-admin-user"}
			return
		end
	end

	def home
		
	end

	def google_login_post
		ga = GoogleAuth.new		
		session[:admin_user_id] = nil

		begin
			
			authorization = ga.exchange_code(params[:authorization_code])
			user_info = ga.get_user_info(authorization)

			if user_info.email.match(/.*@sowntogrow.com/)
				session[:admin_user_id] = user_info.id							
			end			

			respond_to do |format|
			if session[:admin_user_id] #successful teacher login				
				
					format.json { render json: {login_response: "success", user_type: "admin", error: nil} }				

			else #catch all for unsuccessful login								
					format.json { render json: {login_response: "error", user_type: nil, error: "invalid-credentials"} }

			end		
		end

		rescue
			render json: {status: "error", message: "unknown-authentication-error"}	
		end

	end

	def logged_in

		if session[:admin_user_id] 
			render json: {status: "success"}
		else
			render json: {status: "error"}
		end

	end

	def sign_out
		session[:admin_user_id] = nil

		render json: {status: "success"}

	end

	def search_users


			begin
				id = Integer(params[:searchTerm])
			rescue
				id = nil
			end

			teachers = TeacherUser.where("lower(first_name) like ? or lower(last_name) like ? or lower(display_name) like ? or id = ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", id).as_json
			students = StudentUser.where("lower(first_name) like ? or lower(last_name) like ? or lower(display_name) like ? or id = ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", id).as_json

			teachers.each do |teacher|
				teacher["user_type"] = "teacher"
			end

			students.each do |student|
				student["user_type"] = "student"
			end

			users = teachers + students

			render json: {status: "success", users: users, searchTerm: params[:searchTerm]}

		
	end

	def become_user


			if(params[:user_type].eql?("teacher"))
				session[:teacher_user_id] = params[:user_id]
			elsif(params[:user_type].eql?("student"))
				session[:student_user_id] = params[:user_id]
			end

			if session[:teacher_user_id] || session[:student_user_id]
				render json: {status: "success"}
			else
				render json: {status: "error", message: "invalid-user-id"}
				
			end

	end


end
