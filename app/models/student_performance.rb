class StudentPerformance < ActiveRecord::Base
	belongs_to :student_user
	belongs_to :classroom_activity_pairing

	validates :scored_performance, numericality: true, :allow_nil => true	
	validates :completed_performance, inclusion: { in: [true, false, nil] }
	validate :scored_performance_within_range

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

	def scored_performance_within_range
		if self.classroom_activity_pairing.activity.activity_type.eql?('scored')
			if !self.classroom_activity_pairing.activity.min_score.nil? && scored_performance < self.classroom_activity_pairing.activity.min_score
				errors.add(:scored_performance, 'is less than allowable minimum score')
			end			
			if !self.classroom_activity_pairing.activity.max_score.nil? && scored_performance > self.classroom_activity_pairing.activity.max_score
				errors.add(:scored_performance, 'is greater than allowable maximum score')
			end
		end
	end

end
