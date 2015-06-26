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
		@classroom = Classroom.find(params[:id])		
	end

	#update a specific classroom
	def update
		@classroom = Classroom.find(params[:id])
		@classroom.update(params.require(:classroom).permit(:name, :description, :classroom_code))

		if(@classroom.save)
			redirect_to '/classroom/' + params[:id]
		else
			render action: 'edit'
		end
	end

	#delete a speciic classroom
	def destroy
		
	end

end
