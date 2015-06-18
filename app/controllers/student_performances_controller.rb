class StudentPerformancesController < ApplicationController

	before_action :require_student_login, only: [:new, :create, :show]

	#return html form for creating a new student performance
	def new		
		if(!@student_performance)
			@student_performance = StudentPerformance.new			
		end
		@student_performance.classroom_activity_pairing_id = params[:classroom_activity_pairing_id]
		@student_performance.student_user_id = @current_student_user.id
	end

	#create a new student performance
	def create
		@student_performance = StudentPerformance.new(params.require(:student_performance).permit(:classroom_activity_pairing_id, :student_user_id, :scored_performance, :completed_performance))		
		if(@student_performance.save)
			redirect_to "/student/viewClassroom?classroom_id=#{@student_performance.classroom_activity_pairing.classroom_id}"
		else
			@student_performance.errors.each do |k,v|
				puts v
			end
			render action: 'new'
		end
	end

	#display a specific student performance (might use this to show students)
	def show
		#TODO: Need security to prevent people from seeing classrooms that aren't theirs
		@classroom = Classroom.find(params[:id])
		@activites_and_student_performance = @classroom.get_activities_and_student_performance_data_all
	end

	#return html form for editing a student performance
	def edit
		@classroom = Classroom.find(params[:id])		
	end

	#update a specific student performance	
	def update
		@classroom = Classroom.find(params[:id])
		@classroom.update(params.require(:classroom).permit(:name, :description, :classroom_code))

		if(@classroom.save)
			redirect_to '/classroom/' + params[:id]
		else
			render action: 'edit'
		end
	end

	#delete a specific student performance
	def destroy
		
	end

	def edit_all
		@classroom = Classroom.find(params[:classroom_id])
		@activites_and_student_performance = @classroom.get_activities_and_student_performance_data_all
	end

	def save_all
		
		@classroom = Classroom.find(params[:classroom_id])
		student_performance_hash = params[:studentPerformance]

		student_performance_hash.each do |activity_id, student_activity_performances|
			cap = ClassroomActivityPairing.where({activity_id: activity_id, classroom_id: @classroom.id}).first
			activity = cap.activity
			student_activity_performances.each do |student_user_id, performance| 
				stored_performance = StudentPerformance.where({student_user_id: student_user_id, classroom_activity_pairing_id: cap.id}).first
				if activity.activity_type.eql?('scored')
					if(stored_performance.nil? && !performance.strip.eql?(''))	
						StudentPerformance.new({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id, scored_performance: performance}).save
					elsif !stored_performance.nil?
						stored_performance.scored_performance = performance.to_f
						stored_performance.save
					end

				elsif activity.activity_type.eql?('completion')
					if(stored_performance.nil? && performance.eql?('true'))	
						StudentPerformance.new({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id, scored_performance: true}).save
					elsif !stored_performance.nil?
						stored_performance.completed_performance = performance
						stored_performance.save
					end
				end			
					
			end
		end

		redirect_to '/student_performance/edit_all?classroom_id='	+ params[:classroom_id].to_s
	end

end
