class ActivitiesController < ApplicationController
	def index

		if(params[:searchTerm] && params[:searchTerm][0].eql?('#'))
			tagArray = params[:searchTerm].split(/ +/)
			puts tagArray
			@activities = Activity.where({teacher_user_id: @current_teacher_user.id}).reject do |act| 
				condition = true
				tagArray.each do |t|
					if act.tag_match(t[1..t.length])
						condition = false
					end
				end
				condition
			end
		else

			@activities = Activity.where({teacher_user_id: @current_teacher_user.id}).reject do |act| 
				!act.search_match(params[:searchTerm]) || !act.tag_match(params[:tag])
			end

		end

		
	end

	#return and html form for creating a new activity
	def new
		if(!@activity)
			@activity = Activity.new			
		end
	end

	#create an activity
	def create
		@activity = Activity.new(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score))
		@activity.teacher_user_id = session[:teacher_user_id]

		if(@activity.save)

			#save the tags
			params[:tags] = params[:tags].nil? ? {} : params[:tags]
			params[:tags].each do |index, value| 
				#check if the tag exists, if it doesn't create it
				puts "index: #{index}, value: #{value}"
				tag = ActivityTag.where({name: value}).first_or_initialize({name: value})
				if(!tag.save)
					tag.errors.each do |k,v|
						puts "ERROR - #{k}: #{v}"
					end
				end

				#save the activity tag pair
				atp = ActivityTagPairing.new({activity_id: @activity.id, activity_tag_id: tag.id})
				if !atp.save
					atp.errors.each do |k, v|
						puts "ERROR - #{k}: #{v}"
					end
				end
			end


			redirect_to '/activities'
		else
			@activity.errors.each do |k,v|
				puts "#{k}: #{v}"
			end
			render action: 'new'
		end
	end

		#return html form for editing a classroom
	def edit
		@activity = Activity.exists?(params[:id]) ? Activity.find(params[:id]) : nil
		@classrooms = @current_teacher_user.classrooms	
	end

	#update a specific activity
	def update
		@activity = Activity.exists?(params[:id]) ? Activity.find(params[:id]) : nil
		if !@activity.nil?
			@activity.update(params.require(:activity).permit(:name, :description, :instructions, :activity_type, :min_score, :max_score, :benchmark1_score, :benchmark2_score))

			if(@activity.save)

				#go through all the submitted tags and add/delete as necessary				
				params[:tags] = params[:tags].nil? ? {} : params[:tags]
				params[:tags].each do |index, value| 
					#check if the tag exists, if it doesn't create it
					puts "index: #{index}, value: #{value}"
					tag = ActivityTag.where({name: value}).first_or_initialize({name: value})
					if(!tag.save)
						tag.errors.each do |k,v|
							puts "ERROR - #{k}: #{v}"
						end
					end

					#create a new activity tag pair if it doesn't exist
					atp = ActivityTagPairing.where({activity_id: @activity.id, activity_tag_id: tag.id}).first_or_initialize					
					if !atp.save
						atp.errors.each do |k, v|
							puts "ERROR - #{k}: #{v}"
						end
					end
				end

				#delete all tag pairings from the database if they aren't in the submitted list
				@activity.activity_tag_pairings.each do |existing_atp|
					if !params[:tags].has_value?(existing_atp.activity_tag.name)
						existing_atp.destroy
					end
				end

				redirect_to '/activities'
			else				
				@classrooms = @current_teacher_user.classrooms	
				render action: 'edit'
			end
		else
			flash[:error] = 'Activity does not exist'
				redirect_to '/activities'
		end
	end

	def assign
		@activity = Activity.exists?(params[:id]) ? Activity.find(params[:id]) : nil
		@classrooms = @current_teacher_user.classrooms		
	end
end
