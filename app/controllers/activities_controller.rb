class ActivitiesController < ApplicationController
	def index
		@activities = current_user.activities
	end

	#return and html form for creating a new activity
	def new
		if(!@activity)
			@activity = Activity.new			
		end
	end

	#create an activity
	def create
		@activity = Activity.new(params.require(:activity).permit(:name, :description, :instructions, :activity_type))
		@activity.teacher_user_id = session[:user_id]
		if(@activity.save)
			redirect_to '/activities'
		else
			render action: 'new'
		end
	end

		#return html form for editing a classroom
	def edit
		@activity = Activity.find(params[:id])		
	end

	#update a specific activity
	def update
		@activity = Activity.find(params[:id])
		@activity.update(params.require(:activity).permit(:name, :description, :instructions, :activity_type))

		if(@activity.save)
			redirect_to '/activities'
		else
			render action: 'edit'
		end
	end
end
