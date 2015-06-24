class ActivityTagsController < ApplicationController

	def create
			if params[:activity_tag][:name]
				@activity_tag = ActivityTag.where({name: params[:activity_tag][:name]}).first
				if @activity_tag.nil?
					@activity_tag = ActivityTag.new(params.require(:activity_tag).permit(:name))
					@activity_tag.save									
				end

				activity_tag_id = @activity_tag.id
				ActivityTagPairing.new({activity_id: params[:activity_tag][:activity_id], activity_tag_id: activity_tag_id}).save

				redirect_to params[:activity_tag][:redirect_path]
			end
	end

end
