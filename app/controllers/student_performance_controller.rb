class StudentPerformanceController < ApplicationController

	def edit_all
		@classroom = Classroom.find(params[:classroom_id])
		@activites_and_student_performance = @classroom.get_activities_and_student_performance_data
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
