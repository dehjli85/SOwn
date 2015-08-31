class StudentPerformance < ActiveRecord::Base
	belongs_to :student_user
	belongs_to :classroom_activity_pairing
	has_one :activity, :through => :classroom_activity_pairing

	validates :scored_performance, numericality: true, :allow_nil => true	
	validates :completed_performance, inclusion: { in: [true, false, nil] }
	validate :scored_performance_within_range
	validates :performance_date, :student_user_id, :classroom_activity_pairing_id, presence: true

	##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

	def scored_performance_within_range
		if self.classroom_activity_pairing.activity.activity_type.eql?('scored')
			if scored_performance.nil?
				errors.add(:scored_performance, 'cannot be blank')
				return
			end
			if !self.classroom_activity_pairing.activity.min_score.nil? && scored_performance < self.classroom_activity_pairing.activity.min_score
				errors.add(:scored_performance, 'is less than allowable minimum score')
			end			
			if !self.classroom_activity_pairing.activity.max_score.nil? && scored_performance > self.classroom_activity_pairing.activity.max_score
				errors.add(:scored_performance, 'is greater than allowable maximum score')
			end
		end
	end

	##################################################################################################
  #
  # Pretty Properties
  #
  ##################################################################################################

  # set the pretty performance and color given an activity (should be a hash with the activity properties)
  def set_pretty_properties(activity_hash)
  	@performance_color = StudentPerformance.performance_color_no_active_record(activity["activity_type"],activity["benchmark1_score"],activity["benchmark2_score"],activity["min_score"],activity["max_score"],self.scored_performance, self.completed_performance)
  	@performance_pretty = StudentPerformance.performance_pretty_no_active_record(activity["activity_type"],self.scored_performance, self.completed_performance)
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
			if scored_performance.nil? || (benchmark1_score.nil? && benchmark2_score.nil?) || min_score.nil? || max_score.nil?
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

	def to_s
		return "classroom_activity_pairing_id: #{classroom_activity_pairing_id}, scored_performance: #{scored_performance}, completed_performance: #{completed_performance}, performance_date: #{performance_date}"
	end

	##################################################################################################
  #
  # Model API Methods
  #
  ##################################################################################################

  def activity
		self.classroom_activity_pairing.activity
	end

	def activity_type
		self.classroom_activity_pairing.activity.activity_type
	end

	def requires_verification?
		return !StudentPerformanceVerification.where({student_user_id: student_user_id, classroom_activity_pairing_id: classroom_activity_pairing_id}).empty?
	end

	# Returns a Result set containing Student Performances for the specified classroom
	# Result set is filtered by specified arguments
	# Student Performance objects have the following addtional fields:
	# => Activity fields, 
	# => Classroom Activity Pairing sort_order
	# => Student User id, first_name, last_name, display_name
	def self.student_performances_with_verification(classroomId, searchTerm=nil, tagId=nil, studentUserId=nil, includeHidden=true)

		if(!(searchTerm.nil? || searchTerm.eql?('')) && searchTerm[0].eql?('#'))
			tag_array = searchTerm.gsub('#','').split(/ +/)
		else
			tag_array = nil
		end

		arguments = [nil, classroomId]
		
		sql = 'SELECT distinct spv.student_user_id is not null as requires_verification, 
						student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, 
						a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, 
						classroom_activity_pairings.sort_order, 
						student_performances.* 
					FROM "student_performances" 
					INNER JOIN "student_users" ON "student_users"."id" = "student_performances"."student_user_id" 
					INNER JOIN "classroom_student_users" ON "classroom_student_users"."student_user_id" = "student_users"."id" and "classroom_student_users"."classroom_id" = ?
					INNER JOIN "classroom_activity_pairings" ON "classroom_activity_pairings"."id" = "student_performances"."classroom_activity_pairing_id" 
					INNER JOIN activities a on a.id =  classroom_activity_pairings.activity_id 
					LEFT JOIN activity_tag_pairings atp on atp.activity_id = a.id'


		if !tag_array.nil?
			sql += ' LEFT JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.name in (?)'
			arguments.push(tag_array)
		elsif searchTerm
			sql += ' LEFT JOIN activity_tags tags on tags.id = atp.activity_tag_id'	
		elsif tagId
			sql += ' INNER JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.id = ?'
			arguments.push(tagId)
		end

		sql += ' LEFT OUTER JOIN student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id and student_users.id = spv.student_user_id 
					WHERE (classroom_activity_pairings.classroom_id = ?)'
		arguments.push(classroomId)

		if tag_array
      sql += ' AND tags.name in (?)'
      arguments.push(tag_array)
    elsif searchTerm && tag_array.nil?
			sql += ' AND (lower(tags.name) like ? or lower(a.name) like ? or lower(a.description) like ?)'			
			arguments.push("%#{searchTerm.downcase}%")			
			arguments.push("%#{searchTerm.downcase}%")			
			arguments.push("%#{searchTerm.downcase}%")			
		end

		if studentUserId
			sql += ' AND "student_users"."id" = ?'
			arguments.push(studentUserId)
		end

		if !includeHidden
			sql += ' AND classroom_activity_pairings.hidden = false'
		end

		sql	+= ' ORDER BY id DESC'		

		arguments[0] = sql

		sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
		student_performances = ActiveRecord::Base.connection.execute(sanitized_query)
	end
	

end
