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
		StudentPerformance.performance_color_no_active_record(@activity.activity_type, @activity.benchmark1_score, @activity.benchmark2_score, @activity.min_score, @activity.max_score, self.scored_performance, self.completed_performance)
	end

	def self.performance_color_no_active_record(activity_type, benchmark1_score, benchmark2_score, min_score, max_score, scored_performance, completed_performance)
		benchmark1_score = benchmark1_score ? benchmark1_score.to_f : nil
		benchmark2_score = benchmark2_score ? benchmark2_score.to_f : nil
		min_score = min_score ? min_score.to_f : nil
		max_score = max_score ? max_score.to_f : nil
		scored_performance = scored_performance ? scored_performance.to_f : nil

		if activity_type.eql?('scored')
			if (benchmark1_score.nil? && benchmark2_score.nil?) || min_score.nil? || max_score.nil?
				return 'none'
			elsif !benchmark2_score.nil? && benchmark1_score.nil?
				if scored_performance <= max_score && scored_performance > benchmark2_score
					return 'success-sown'
				else
					return 'warning-sown'
				end
			elsif !benchmark1_score.nil? && benchmark2_score.nil?
				if scored_performance <= max_score && scored_performance > benchmark1_score
					return 'success-sown'
				else
					return 'danger-sown'
				end
			elsif !benchmark1_score.nil? && !benchmark2_score.nil?
				if scored_performance <= max_score && scored_performance > benchmark2_score
					return 'success-sown'
				elsif scored_performance <= benchmark2_score && scored_performance > benchmark1_score
					return 'warning-sown'
				else					
					return 'danger-sown'
				end
			end
		elsif activity_type.eql?('completion')
			if completed_performance.nil? || completed_performance.eql?('')
				return 'none'
			elsif completed_performance == true || completed_performance.eql?('t')
				return 'success-sown'
			else
				return 'danger-sown'
			end
		end
	end

	def performance_color=(p)
		@performance_color = p
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
		
		return StudentPerformance.performance_pretty_no_active_record(self.classroom_activity_pairing.activity.activity_type, self.scored_performance, self.completed_performance)
		
	end

	def self.performance_pretty_no_active_record(activity_type, scored_performance, completed_performance)

		if activity_type.eql?('scored')

			return scored_performance.to_i == scored_performance ? scored_performance.to_i : scored_performance
		
		elsif activity_type.eql?('completion')
			
			case 
			when completed_performance == true || completed_performance.eql?('t')
				return 'Completed'
			when completed_performance == false || completed_performance.eql?('f')
				return 'Not Completed'
			when nil
				return 'Not Attempted'
			end

		else
			return nil
		end				
		
	end

	def performance_pretty=(p)
		@performance_pretty = p
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
