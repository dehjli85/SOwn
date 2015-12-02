class AdminController < ApplicationController

	require 'csv'

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
			
			# authorization = ga.exchange_code(params[:authorization_code])
			# user_info = ga.get_user_info(authorization)

			userinfo = ga.get_userinfo_from_id_token(params[:id_token])


			puts "User Info: #{userinfo}"

			if userinfo["email"].match(/.*@sowntogrow.com/)
				session[:admin_user_id] = userinfo["email"]							
			end			

			respond_to do |format|
			if session[:admin_user_id] #successful teacher login				
				
					format.json { render json: {login_response: "success", user_type: "admin", error: nil} }				

			else #catch all for unsuccessful login								
					format.json { render json: {login_response: "error", user_type: nil, error: "invalid-credentials"} }

			end		
		end

		rescue => error
			puts error
			render json: {status: "error", error: "unknown-authentication-error", message: "unknown-authentication-error"}	
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

			teachers = TeacherUser.where("lower(first_name) like ? or lower(last_name) like ? or lower(display_name) like ? or lower(email) like ? or id = ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", id)
				.order("id ASC")
				.as_json
			students = StudentUser.where("lower(first_name) like ? or lower(last_name) like ? or lower(display_name) like ? or lower(email) like ? or id = ?", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", "%#{params[:searchTerm].downcase}%", id)
				.order("id ASC")
				.as_json

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

				#set the session value for the teacher id
				teacher_user = TeacherUser.where(id: params[:user_id]).first
				session[:teacher_user_id] = teacher_user.id

				#check to see if they have a student account and set that as well
				student_user = StudentUser.where(email: teacher_user.email).first
				if !student_user.nil?
					session[:student_user_id] = student_user.id
				else
					session[:student_user_id] = nil
				end

			elsif(params[:user_type].eql?("student"))

				#set the session value for the student id				
				student_user = StudentUser.where(id: params[:user_id]).first
				session[:student_user_id] = params[:user_id]

				#check to see if they have a teacher account and set that as well				
				teacher_user = TeacherUser.where(email: student_user.email).first
				if !teacher_user.nil?
					session[:teacher_user_id] = teacher_user.id
				else
					session[:teacher_user_id] = nil
				end

			end

			if session[:teacher_user_id] || session[:student_user_id]
				render json: {status: "success"}
			else
				render json: {status: "error", message: "invalid-user-id"}
				
			end

	end

	def summary_metrics
			cumulative_student_user_counts = StudentUser.cumulative_create_count_by_week
			cumulative_teacher_user_counts = TeacherUser.cumulative_create_count_by_week
			cumulative_student_performance_counts = StudentPerformance.cumulative_create_count_by_week
			cumulative_activity_counts = Activity.cumulative_create_count_by_week
			render json: {status: "success", 
				cumulative_student_performance_counts: cumulative_student_performance_counts,
				cumulative_activity_counts: cumulative_activity_counts,
				cumulative_student_user_counts: cumulative_student_user_counts,
				cumulative_teacher_user_counts: cumulative_teacher_user_counts}
	end

	def user_metrics
		if params[:userType].eql?("teacher")
			student_user_counts = StudentUser.count(params[:id])
			student_performance_counts = StudentPerformance.count("teacher", params[:id])
			activity_counts = Activity.count(params[:id])
			classroom_counts = Classroom.count("teacher", params[:id])
			teacher = TeacherUser.find(params[:id])

			render json: {status: "success", 
				teacher:teacher,
				student_performance_counts: student_performance_counts,
				activity_counts: activity_counts,
				classroom_counts: classroom_counts,
				student_user_counts: student_user_counts}

		elsif params[:userType].eql?("student")
			classroom_counts = Classroom.count("student", params[:id])
			student_performance_counts = StudentPerformance.count("student", params[:id])
			student = StudentUser.find(params[:id])

			render json: {status: "success", 
				student: student,
				student_performance_counts: student_performance_counts,
				classroom_counts: classroom_counts}

		end

	end

	def update_password
    
    new_password = params[:newPassword]
    
    if params[:userType].eql?('teacher')

    	teacher_user = TeacherUser.where(id: params[:id]).first

    	if !(teacher_user && teacher_user.provider.nil?)
	      render json: {status: "error", message: "unable-to-update-password-for-specified-user"}
	    else
	      
        teacher_user.password = new_password

        if !teacher_user.save
          render json: {status: "error", message: "unable-to-update-password-for-specified-user"}
        else
          render json: {status: "success"}        
        end

	    end

    elsif params[:userType].eql?('student')

    	student_user = StudentUser.where(id: params[:id]).first

    	if !(student_user && student_user.provider.nil?)
	      render json: {status: "error", message: "unable-to-update-password-for-specified-user"}
	    else
	      
        student_user.password = new_password

        if !student_user.save
          render json: {status: "error", message: "unable-to-update-password-for-specified-user"}
        else
          render json: {status: "success"}        
        end

	    end

    else
      render json: {status: "error", message: "user-type-not-specified"}
    end

    # check that it's a sown to grow account and the old password matches
    

    
  end

  def upload_roster

  	# read the csv file
  	File.read(params[:roster_file].tempfile)

  	new_students = Array.new
  	classroom_ids = Array.new
  	student_errors = Array.new
  	classroom_errors = Array.new
  	header_row = true
  	CSV.foreach(params[:roster_file].tempfile) do |row|
	  	
	  	# skip the header row
	  	if header_row
	  		header_row = false

  		# loop through all other rows
	  	else

		  	# create a student
	  		new_student = StudentUser.new({first_name: row[0], last_name: row[1], display_name: row[0] + " " + row[1], username: row[2], email: row[2], password: row[3]})

	  		if(new_student.valid?)
	  			new_students.push(new_student)
	  		else
	  			student_hash = new_student.as_json
	  			student_hash["errors"] = new_student.errors
	  			student_errors.push(student_hash)
	  		end

	  		if Classroom.where(id: row[4]).first.nil?
	  			classroom_errors.push(row[4])
	  		else
	  			classroom_ids.push(row[4])
	  		end

	  	end
  	end

  	# check all students are valid
  	if student_errors.empty? && classroom_errors.empty? && classroom_ids.length.eql?(new_students.length)

  		#s save each student and pairing
  		new_students.each_with_index do |student, index|
  			student.save
  			ClassroomStudentUser.new({student_user_id: student.id, classroom_id: classroom_ids[index]}).save
  		end

  		render json: {status: "success"}

  	else
  		render json: {status: "error", student_errors: student_errors, classroom_errors: classroom_errors}
  		

  	end



  end


end
