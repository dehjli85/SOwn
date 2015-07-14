class StudentPerformance < ActiveRecord::Base
	belongs_to :student_user
	belongs_to :classroom_activity_pairing
	has_one :activity, :through => :classroom_activity_pairing

	validates :scored_performance, numericality: true, :allow_nil => true	
	validates :completed_performance, inclusion: { in: [true, false, nil] }
	validate :scored_performance_within_range
	validates :performance_date, presence: true

	def requires_verification?
		return !StudentPerformanceVerification.where({student_user_id: student_user_id, classroom_activity_pairing_id: classroom_activity_pairing_id}).empty?
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

	def activity
		self.classroom_activity_pairing.activity
	end

	def performance_color
		@activity = self.activity
		if @activity.activity_type.eql?('scored')
			if (@activity.benchmark1_score.nil? && @activity.benchmark2_score.nil?) || @activity.min_score.nil? || @activity.max_score.nil?
				return 'none'
			elsif !@activity.benchmark2_score.nil? && @activity.benchmark1_score.nil?
				if scored_performance <= @activity.max_score && scored_performance > @activity.benchmark2_score
					return 'success-sown'
				else
					return 'warning-sown'
				end
			elsif !@activity.benchmark1_score.nil? && @activity.benchmark2_score.nil?
				if scored_performance <= @activity.max_score && scored_performance > @activity.benchmark1_score
					return 'success-sown'
				else
					return 'danger-sown'
				end
			elsif !@activity.benchmark1_score.nil? && !@activity.benchmark2_score.nil?
				if scored_performance <= @activity.max_score && scored_performance > @activity.benchmark2_score
					return 'success-sown'
				elsif scored_performance <= @activity.benchmark2_score && scored_performance > @activity.benchmark1_score
					return 'warning-sown'
				else					
					return 'danger-sown'
				end
			end
		elsif @activity.activity_type.eql?('completion')
			if completed_performance
				return 'success-sown'
			else
				return 'danger-sown'
			end
		end
	end

	

	def performance
		if self.classroom_activity_pairing.activity.activity_type.eql?('scored')
			return self.scored_performance
		elsif self.classroom_activity_pairing.activity.activity_type.eql?('completion')
			return self.completed_performance
		else
			return nil
		end				
	end

	def performance_pretty
		if self.classroom_activity_pairing.activity.activity_type.eql?('scored')

			return scored_performance.to_i == scored_performance ? scored_performance.to_i : scored_performance
		
		elsif self.classroom_activity_pairing.activity.activity_type.eql?('completion')
			
			case self.completed_performance
			when true
				return 'Completed'
			when false 			
				return 'Not Completed'
			when nil
				return 'Not Attempted'
			end

		else
			return nil
		end				
	end

	def activity_type
		self.classroom_activity_pairing.activity.activity_type
	end

	#NEED TO DEPREACATE USE OF THIS METHOD
	def scored_performance_pretty
		scored_performance.to_i == scored_performance ? scored_performance.to_i : scored_performance
	end

	#NEED TO DEPREACATE USE OF THIS METHOD
	def completed_performance_desc
		case self.completed_performance
		when true
			'Completed'
		when false 			
			'Not Completed'
		when nil
			'Not Attempted'
		end
		
	end

end
