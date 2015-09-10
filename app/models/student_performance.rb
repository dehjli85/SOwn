class StudentPerformance < ActiveRecord::Base
	belongs_to :student_user
	belongs_to :classroom_activity_pairing
	has_one :activity, :through => :classroom_activity_pairing

	validates :performance_date, :student_user_id, :classroom_activity_pairing_id, presence: true
	validates :scored_performance, numericality: true, :allow_nil => true	
	validate :student_user_exists
	validate :classroom_activity_pairing_exists
	validate :scored_performance_within_range
	validate :completed_performance_not_nil
	validates :completed_performance, inclusion: { in: [true, false, nil] }

	##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

	def student_user_exists
		if StudentUser.where(id: student_user_id).empty?
			errors.add(:student_user_id, "is not a valid student")
		end
	end

	def classroom_activity_pairing_exists
		if ClassroomActivityPairing.where(id: classroom_activity_pairing_id).empty?
			errors.add(:classroom_activity_pairing_id, "is not a valid classroom assigned activity")
		end
	end

	def scored_performance_within_range
		if self.activity && self.activity.activity_type.eql?('scored')
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

	def completed_performance_not_nil
		if self.activity && self.activity.activity_type.eql?('completion')
			if self.completed_performance.nil?
				errors.add(:completed_performance, 'cannot be blank')
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

  # This method converts a hash object to an Activity.  Originally created for testing purposes when working with executed SQL queries
  def self.from_hash(hash={})
    
    sp = StudentPerformance.new
    sp.id = hash["id"]
    sp.student_user_id = hash["student_user_id"]
    sp.classroom_activity_pairing_id = hash["classroom_activity_pairing_id"]
    sp.scored_performance = hash["scored_performance"]
    sp.completed_performance = hash["completed_performance"]
    sp.performance_date = hash["performance_date"]
    sp.verified = hash["verified"]
    sp.created_at = hash["created_at"]
    sp.updated_at = hash["updated_at"]

    return sp
  end

  # Returns the activity associated with the Student Performance
  # Returns nil if the Classroom Activity Pairing is invalid
  def activity
		self.classroom_activity_pairing ? self.classroom_activity_pairing.activity : nil
	end

	# Returns the activity associated with the Student Performance
  # Returns nil if the Classroom Activity Pairing is invalid
	def activity_type
		self.classroom_activity_pairing && self.classroom_activity_pairing.activity ? self.classroom_activity_pairing.activity.activity_type : nil
	end

	def requires_verification?
		return !StudentPerformanceVerification.where({student_user_id: student_user_id, classroom_activity_pairing_id: classroom_activity_pairing_id}).empty?
	end


	# Returns an Array of Hashes representing Student Performances for the Classroom with id = classroomId
  # In addition to all activity fields, all Hashes in the Array also include:
  #   => the Classroom Activity Pairing id, sort_order, hidden and due_date fields 
  # 	=> the Student User id, first_name, last_name, and display_name fields
  # If an invalid classroomId (i.e. Classroom doesn't exist) is passed, returns nil
  #
  # Uses:
  #  searchTerm: if the first character is a '#', all '#'s are removed from the string, and it is treated as a space separated list of tags.  
  # 								=> Returns only Student Performances for Activities with one or more of the tags in the list
  #                 EXAMPLES: "#tag1 #tag2" => ('tag1', 'tag2').  "#tag1#tag2" => ('tag1tag2').  "#tag1 tag2" => ('tag1',' tag2')
  #
  #              if the first character is not a '#'
  # 								=> Returns Student Performances for Activities that have a name, description, or Tag name containing the string (case insensitive)
  #
  #  tagId: returns Student Performances for Activities that have been tagged with the Activity Tag with id = tagId
  #  includeHidden: boolean argument that determines whether Student Performances for Activities assigned to Classrooms but are hidden should be returned.  Method by default returns all Activities.
  #
  # WARNING: searchTerm and tagId cannot be used together.  If both are passed to the method, searchTerm will be used and tagId will be ignored
	def self.student_performances_with_verification(classroomId, searchTerm=nil, tagIds=nil, studentUserId=nil, includeHidden=true)

		if Classroom.where(id: classroomId).empty?
      return nil
    end
    
		if(!(searchTerm.nil? || searchTerm.eql?('')) && searchTerm[0].eql?('#'))
			tag_array = searchTerm.gsub('#','').split(/ +/)
		else
			tag_array = nil
		end

		arguments = [nil, classroomId]
		
		sql = 'SELECT distinct spv.student_user_id is not null as requires_verification, 
						student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, 
						a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, 
						classroom_activity_pairings.sort_order, classroom_activity_pairings.hidden, classroom_activity_pairings.due_date, 
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
		elsif tagIds
			sql += ' INNER JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.id in (?)'
			arguments.push(tagIds)
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
		student_performances = ActiveRecord::Base.connection.execute(sanitized_query).to_a

		student_performances.each do |performance|

      performance["performance_pretty"] = 
      	StudentPerformance.performance_pretty_no_active_record(
      		performance["activity_type"], 
      		performance["scored_performance"], 
      		performance["completed_performance"]
    		)

      performance["performance_color"] = 
      	StudentPerformance.performance_color_no_active_record(
      		performance["activity_type"], 
      		performance["benchmark1_score"], 
      		performance["benchmark2_score"], 
      		performance["min_score"], 
      		performance["max_score"], 
      		performance["scored_performance"], 
      		performance["completed_performance"]
      	)
    end


    return student_performances

	end
	
	# Returns an Array of Hashes representing Student Users and ther proficiency % for the Classroom with id = classroomId
  # If an invalid classroomId (i.e. Classroom doesn't exist) is passed, returns nil
  #
  # Uses:
  #  searchTerm: if the first character is a '#', all '#'s are removed from the string, and it is treated as a space separated list of tags.  
  # 								=> Only includes Activities with one or more of the tags in the list when calculating proficiency %
  #                 EXAMPLES: "#tag1 #tag2" => ('tag1', 'tag2').  "#tag1#tag2" => ('tag1tag2').  "#tag1 tag2" => ('tag1',' tag2')
  #
  #              if the first character is not a '#'
  # 								=> Only includes Activities that have a name, description, or Tag name containing the string (case insensitive) when calculating proficiency %
  #
  #  tagId: Only includes Activities that have been tagged with the Activity Tag with id = tagId when calculating proficency %
  #  includeHidden: boolean argument that determines whether Activities assigned to Classrooms but are hidden should be included when calculating proficiency %.  Method by default excludes hidden Activities.
  #
  # WARNING: searchTerm and tagId cannot be used together.  If both are passed to the method, searchTerm will be used and tagId will be ignored
	def self.student_performance_proficiencies(classroomId, searchTerm=nil, tagIds=nil, studentUserId=nil, includeHidden=false)

		if Classroom.where(id: classroomId).empty?
      return nil
    end
    
		if(!(searchTerm.nil? || searchTerm.eql?('')) && searchTerm[0].eql?('#'))
			tag_array = searchTerm.gsub('#','').split(/ +/)
		else
			tag_array = nil
		end

		arguments = [nil, classroomId]
		
		sql = 'SELECT student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, 
						COUNT(DISTINCT CASE WHEN completed_performance = true or scored_performance > greatest(benchmark1_score, benchmark2_score) THEN "classroom_activity_pairings"."id" ELSE NULL END) AS proficient_count
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
		elsif tagIds
			sql += ' INNER JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.id in (?)'
			arguments.push(tagIds)
		end

		sql += ' WHERE (classroom_activity_pairings.classroom_id = ?) AND classroom_activity_pairings.due_date is not null and classroom_activity_pairings.due_date < current_date'
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

		sql	+= ' GROUP BY student_users.id, student_users.display_name, student_users.last_name'		

		arguments[0] = sql

		sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
		student_proficiencies = ActiveRecord::Base.connection.execute(sanitized_query).to_a


    return student_proficiencies

	end

end
