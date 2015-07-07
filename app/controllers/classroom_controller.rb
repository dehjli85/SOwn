class ClassroomController < ApplicationController

	before_action :require_teacher_login

	#view all classrooms (probably won't use this)
	def index
		
	end

	#return html form for creating a new classroom
	def new
		
		if(!@classroom)
			@classroom = Classroom.new			
		end
	end

	#create a new classroom
	def create
		@classroom = Classroom.new(params.require(:classroom).permit(:name, :description, :classroom_code))
		@classroom.teacher_user_id = session[:user_id]
		if(@classroom.save)
			redirect_to '/teacher_home'
		else
			render action: 'new'
		end
	end

	#display a specific classroom (might use this to show students)
	def show
		#TODO: Need security to prevent people from seeing classrooms that aren't theirs
		@classroom = Classroom.find(params[:id])
		#@activites_and_student_performance = @classroom.get_activities_and_student_performance_data_all
		@student_performances = @classroom.student_performances



	end

	#return html form for editing a classroom
	def edit
		@classroom = Classroom.exists?(params[:id]) ? Classroom.find(params[:id]) : nil
	end

	#update a specific classroom
	def update
		@classroom = Classroom.exists?(params[:id]) ? Classroom.find(params[:id]) : nil
		if @classroom
			@classroom.update(params.require(:classroom).permit(:name, :description, :classroom_code))

			if(@classroom.save)
				redirect_to '/classroom/' + params[:id]
			else
				render action: 'edit'
			end
		else
			flash[:notice] = "Classroom doesn't exists"
			render action: 'classroom_error'
		end
	end
		

	#delete a speciic classroom
	def destroy
		
	end

	#return html edit page to assign and edit activities
	def edit_activities
		@classroom = Classroom.find(params[:classroom_id])
		@activities = @current_teacher_user.activities


		if params[:activity_id].nil? || !Activity.exists?(params[:activity_id])			
			@activity = @activities.first
		else						
			@activity = Activity.find(params[:activity_id])
		end		

		@verifications_hash = Hash.new
		@classroom.student_users.each do |student|
			@verifications_hash[student] = nil
		end

		@classroom_activity_pairing = ClassroomActivityPairing.where({classroom_id: @classroom.id, activity_id: @activity.id}).first
		# puts @classroom_activity_pairing
		if !@classroom_activity_pairing.nil?
			@student_performance_verifications = @classroom_activity_pairing.student_performance_verifications	
		end

		if !@student_performance_verifications.nil?
			@student_performance_verifications.each do |verification|
				if @verifications_hash.has_key?(verification.student_user)
					@verifications_hash[verification.student_user] = verification
				end
			end
		end
		

	end

	#save activites
	def save_activities
		@classroom = Classroom.find(params[:classroom_id])
		@activity = Activity.find(params[:activity_id])
		@activities = @current_teacher_user.activities

		flash[:notice] = nil

		@classroom_activity_pairing = ClassroomActivityPairing.where({classroom_id: @classroom.id, activity_id: @activity.id}).first
		begin
			!params[:assigned].nil?
		rescue 
			
		end
		if !params[:assigned].nil? && params[:assigned].eql?('true') && @classroom_activity_pairing.nil?
			@classroom_activity_pairing = ClassroomActivityPairing.new({classroom_id:@classroom.id, activity_id: @activity.id})
			if @classroom_activity_pairing.save
				flash[:notice] = 'Activity Assigned!'
			else
				flash[:notice] = 'Failed to Assign Activity'
			end
		elsif (params[:assigned].nil? || params[:assigned].eql?('false')) && !@classroom_activity_pairing.nil?
			if @classroom_activity_pairing.destroy
				@classroom_activity_pairing = nil
				flash[:notice] = 'Activity Unassigned!'
			else
				flash[:notice] = 'Failed to Unassign Activity'
			end
		end

		if @classroom_activity_pairing			
		

			verifications_hash = params[:student_performance_verification] 
			verifications_hash ||= Hash.new

			@classroom.student_users.each do |student|
				begin
					puts !verifications_hash.nil?
					puts verifications_hash.has_key?(student.id.to_s)
					puts !StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first
				rescue
				end
				if verifications_hash.has_key?(student.id.to_s) && !StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first

					@student_performance_verification = StudentPerformanceVerification.new({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id})
					if @student_performance_verification.save
						puts "Verification created for #{student.display_name} (#{student.id})"
					else
						puts "Error creating verification for #{student.display_name} (#{student.id})"
					end
				elsif !verifications_hash[student.id.to_s] && StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first
					@student_performance_verification = StudentPerformanceVerification.where({student_user_id: student.id, classroom_activity_pairing_id: @classroom_activity_pairing.id}).first
					if @student_performance_verification.destroy
						puts "Verification destroyed for #{student.display_name} (#{student.id})"
					else
						puts "Error destroying verification for #{student.display_name} (#{student.id})"
					end
				end
			end

			@student_performance_verifications = @classroom_activity_pairing.student_performance_verifications	

		else

			@student_performance_verifications = nil

		end
				
		redirect_to '/classroom/edit_activities?classroom_id=' + @classroom.id.to_s + '&activity_id=' + @activity.id.to_s


	end

	def classroom_error
		
	end

end
