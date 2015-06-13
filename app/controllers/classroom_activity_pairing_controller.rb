class ClassroomActivityPairingController < ApplicationController

	def assign
		#get the activity
		activity = Activity.exists?(params[:activity_id]) ? Activity.find(params[:activity_id]) : nil
		#if it exists, update all classrooms associated with it based on the parameters passed
		if !activity.nil?
			puts "activity #{activity.id} exists"
			classroom_hash = params[:classroom_hash].to_h
			current_teacher_user.classrooms.each do |c|
				puts "looking for classroom #{c.id}"
				if classroom_hash.has_value?(c.id.to_s)
					puts "classroom #{c.id} checked"
					if ClassroomActivityPairing.where({activity_id: activity.id, classroom_id: c.id}).empty?
						ca = ClassroomActivityPairing.new
						ca.classroom_id = c.id
						ca.activity_id = activity.id
						ca.save
					end
				else
					puts "classroom #{c.id} not checked"
					ClassroomActivityPairing.delete_all({activity_id: activity.id, classroom_id: c.id})					
				end
			end
		end
		

		redirect_to params[:redirect_path]

	end
end
