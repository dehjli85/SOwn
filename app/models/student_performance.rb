class StudentPerformance < ActiveRecord::Base
	belongs_to :student_user
	belongs_to :classroom_activity_pairing

	validates :scored_performance, numericality: true, :allow_nil => true	
	validates :completed_performance, inclusion: { in: [true, false, nil] }

	def completed_performance_desc
		case self.completed_performance
		when true
			'Completed'
		when false 			
			'Not Completed'
		when nil
			'Not Completed'
		end
		
	end
end
