class StudentPerformance < ActiveRecord::Base
	belongs_to :student_user
	belongs_to :classroom_activity_pairing
	belongs_to :activity_level
	has_one :activity, :through => :classroom_activity_pairing

	
	validates :performance_date, :student_user_id, :classroom_activity_pairing_id, presence: true
	validates :scored_performance, numericality: true, :allow_nil => true	
	validate :student_user_exists
	validate :classroom_activity_pairing_exists
	validate :scored_performance_within_range
	validate :completed_performance_not_nil
	validates :completed_performance, inclusion: { in: [true, false, nil] }

	default_scope {includes(:activity)}
	default_scope {includes(:activity_level)}
	default_scope {includes(:classroom_activity_pairing)}
	

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

	def as_json(options = { })
      # just in case someone says as_json(nil) and bypasses
      # our default...
      super((options || { }).merge({
          :methods => [:set_pretty_properties, :performance_color, :performance_pretty]
      })).merge({"activity" => activity.as_json, "activity_level" => activity_level.as_json, "classroom_activity_pairing" => classroom_activity_pairing.as_json})
  end

	##################################################################################################
  #
  # Pretty Properties
  #
  ##################################################################################################

  # set the pretty performance and color given an activity (should be a hash with the activity properties)
  def set_pretty_properties

		if activity && activity.activity_type.eql?('scored')
			if scored_performance.nil? || (activity.benchmark1_score.nil? && activity.benchmark2_score.nil?) || activity.min_score.nil? || activity.max_score.nil?
				@performance_color = 'none'
			elsif !activity.benchmark2_score.nil? && activity.benchmark1_score.nil?
				if activity.scored_performance <= activity.max_score && scored_performance >= activity.benchmark2_score
					@@performance_color = 'success-sown'
				else
					@performance_color = 'warning-sown'
				end
			elsif !activity.benchmark1_score.nil? && activity.benchmark2_score.nil?
				if scored_performance <= activity.max_score && scored_performance >= activity.benchmark1_score
					@performance_color = 'success-sown'
				else
					@performance_color = 'danger-sown'
				end
			elsif !activity.benchmark1_score.nil? && !activity.benchmark2_score.nil?
				if scored_performance <= activity.max_score && scored_performance >= activity.benchmark2_score
					@performance_color = 'success-sown'
				elsif scored_performance < activity.benchmark2_score && scored_performance >= activity.benchmark1_score
					@performance_color = 'warning-sown'
				else					
					@performance_color = 'danger-sown'
				end
			end
		elsif activity && activity.activity_type.eql?('completion')
			if completed_performance.nil? || completed_performance.eql?('')
				@performance_color = 'none'
			elsif completed_performance == true || completed_performance.eql?('t')
				@performance_color = 'success-sown'
			else
				@performance_color = 'danger-sown'
			end
		end


		activity_level_name_abbreviated = ''
		if !activity_level.nil? && activity_level.abbreviation
			activity_level_name_abbreviated = activity_level.abbreviation + ': '
		end
		
		if activity && activity.activity_type.eql?('scored')

			@performance_pretty = activity_level_name_abbreviated + (scored_performance.to_i == scored_performance ? scored_performance.to_i : scored_performance).to_s
		
		elsif activity && activity.activity_type.eql?('completion')
			
			case 
			when completed_performance == true || completed_performance.eql?('t')
				@performance_pretty = activity_level_name_abbreviated + 'Completed'
			when completed_performance == false || completed_performance.eql?('f')
				@performance_pretty = activity_level_name_abbreviated + 'Not Completed'
			when nil
				@performance_pretty = activity_level_name_abbreviated + 'Not Attempted'
			end

		else
			@performance_pretty = nil
		end		

  end

  def performance_color
		@performance_color
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
				if scored_performance <= max_score && scored_performance >= benchmark2_score
					return 'success-sown'
				else
					return 'warning-sown'
				end
			elsif !benchmark1_score.nil? && benchmark2_score.nil?
				if scored_performance <= max_score && scored_performance >= benchmark1_score
					return 'success-sown'
				else
					return 'danger-sown'
				end
			elsif !benchmark1_score.nil? && !benchmark2_score.nil?
				if scored_performance <= max_score && scored_performance >= benchmark2_score
					return 'success-sown'
				elsif scored_performance < benchmark2_score && scored_performance >= benchmark1_score
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

		@performance_pretty

	end

	def self.performance_pretty_no_active_record(activity_type, scored_performance, completed_performance)

		# level abbreviation
    
 		name_abbreviated = ''

		if activity_type.eql?('scored')

			return name_abbreviated + (scored_performance.to_i == scored_performance ? scored_performance.to_i : scored_performance).to_s
		
		elsif activity_type.eql?('completion')
			
			case 
			when completed_performance == true || completed_performance.eql?('t')
				return name_abbreviated + 'Completed'
			when completed_performance == false || completed_performance.eql?('f')
				return name_abbreviated +' Not Completed'
			when nil
				return name_abbreviated + 'Not Attempted'
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
 #  def activity
	# 	self.classroom_activity_pairing ? self.classroom_activity_pairing.activity : nil
	# end

	# Returns the activity associated with the Student Performance
  # Returns nil if the Classroom Activity Pairing is invalid
	# def activity_type
	# 	self.classroom_activity_pairing && self.classroom_activity_pairing.activity ? self.classroom_activity_pairing.activity.activity_type : nil
	# end

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
	def self.student_performances_with_verification(classroomId, searchTerm=nil, tagIds=nil, studentUserId=nil, includeHidden=true, includeArchived=true)

		if Classroom.where(id: classroomId).empty?
      return nil
    end
    
		if(!(searchTerm.nil? || searchTerm.eql?('')) && searchTerm[0].eql?('#'))
			tag_array = searchTerm.gsub('#','').split(/ +/)
		else
			tag_array = nil
		end

		# classroom_activity_pairings = ClassroomActivityPairing.joins(:activity).joins("left join activity_tag_pairings atp on atp.activity_id = activities.id").joins("left join activity_tags tags on atp.activity_tag_id = tags.id")
		# 	.where(classroom_id: classroomId)
		
		# if !tag_array.nil?
		# 	classroom_activity_pairings = classroom_activity_pairings.where("tags.name in (?)", tag_array)
		# elsif searchTerm && tag_array.nil?
		# 	classroom_activity_pairings = classroom_activity_pairings.where("(lower(tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?)", "%#{searchTerm.downcase}%", "%#{searchTerm.downcase}%", "%#{searchTerm.downcase}%")
		# elsif tagIds
		# 	classroom_activity_pairings = classroom_activity_pairings.where("tags.id in (?)", tagIds)
		# end

		# if !includeHidden
		# 	classroom_activity_pairings = classroom_activity_pairings.where('classroom_activity_pairings.hidden = false')
		# end

		# if !includeArchived
		# 	classroom_activity_pairings = classroom_activity_pairings.where('classroom_activity_pairings.archived= false')
		# end

		# cap_ids = classroom_activity_pairings.pluck(:id)

		# performances = StudentPerformance.where(classroom_activity_pairing_id: cap_ids)
		# performances_json = performances.as_json

		# verifications = StudentPerformanceVerification.where(classroom_activity_pairing_id: cap_ids)
		# verifications_hash = {}
		# verifications.each do |verification|
		# 	verifications_hash[verification["student_user_id"].to_s + "," + verification["classroom_activity_pairing_id"].to_s] = true
		# end

		# performances.each do |performance|
			# performance["requires_verification"] = verifications[performance["student_user_id"].to_s + "," + performance["classroom_activity_pairing_id"].to_s].nil?
			# performance["display_name"] = performance.student_user.display_name
		# 	performance.as_json
		# end

		arguments = [nil, classroomId]
		
		sql = 'SELECT distinct spv.student_user_id is not null as requires_verification, 
						student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, 
						a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, 
						classroom_activity_pairings.sort_order, classroom_activity_pairings.hidden, classroom_activity_pairings.due_date, 
						al.name, al.abbreviation,
						student_performances.*
					FROM "student_performances" 
					INNER JOIN "student_users" ON "student_users"."id" = "student_performances"."student_user_id" 
					INNER JOIN "classroom_student_users" ON "classroom_student_users"."student_user_id" = "student_users"."id" and "classroom_student_users"."classroom_id" = ?
					INNER JOIN "classroom_activity_pairings" ON "classroom_activity_pairings"."id" = "student_performances"."classroom_activity_pairing_id" 
					INNER JOIN activities a on a.id =  classroom_activity_pairings.activity_id 
					LEFT JOIN activity_levels al on "student_performances".activity_level_id = al.id
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

		if !includeArchived
			sql += ' AND classroom_activity_pairings.archived = false'
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
  # WARNING: only returns proficiences for Student Users who have tracked  at least 1 Activity
	def self.student_performance_proficiencies(classroomId, searchTerm=nil, tagIds=nil, studentUserId=nil, includeHidden=false, includeArchived=false)

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
						COUNT(DISTINCT CASE 
							WHEN (a.activity_type = \'completion\' and completed_performance = true) 
								OR (a.activity_type = \'scored\' and scored_performance >= greatest(benchmark1_score, benchmark2_score)) THEN "classroom_activity_pairings"."id" 
							ELSE NULL END) 
						AS proficient_count
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

		# filter out performances that aren't the most recent
		sql += " INNER JOIN (select student_user_id, classroom_activity_pairing_id, max(id) as id from student_performances group by student_user_id, classroom_activity_pairing_id) max_perf on max_perf.id = student_performances.id"

		sql += ' WHERE (classroom_activity_pairings.classroom_id = ?)'
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

		if !includeArchived
			sql += ' AND classroom_activity_pairings.archived = false'
		end

		sql	+= ' GROUP BY student_users.id, student_users.display_name, student_users.last_name'		

		arguments[0] = sql

		sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
		student_proficiencies = ActiveRecord::Base.connection.execute(sanitized_query).to_a

    return student_proficiencies

	end

	# return the number of performances from "real" Student Users
  def self.count(user_type=nil, id=nil)
  	if user_type.nil?

  		exclude_student_user_ids = StudentUser.where("email like '%@sowntogrow.com%'").pluck(:id)
	    StudentPerformance.where("student_user_id not in (?)", exclude_student_user_ids)
	    	.count
  	
  	elsif user_type.eql?("teacher")
  	
  		exclude_student_user_ids = StudentUser.where("email like '%@sowntogrow.com%'").pluck(:id)
	    StudentPerformance.joins(:student_user)
	    	.joins("inner join classroom_student_users csu on csu.student_user_id = student_performances.student_user_id")
	    	.joins("inner join classrooms c on c.id = csu.classroom_id")
        .where("c.teacher_user_id = ?", id)
	    	.where("csu.student_user_id not in (?)", exclude_student_user_ids)
	    	.count

  	elsif user_type.eql?("student")
  		exclude_student_user_ids = StudentUser.where("email like '%@sowntogrow.com%'").pluck(:id)
	    StudentPerformance.where("student_user_id not in (?)", exclude_student_user_ids)
	    	.where("student_user_id = ? ", id)
	    	.count
  	end
  	
  end

  # return the number of all performances
  def self.count_all
  	self.all.count
  end

	# return the number of performances from "real" Student Users by week
  def self.create_count_by_week
    exclude_student_user_ids = StudentUser.where("email like '%@sowntogrow.com%'").pluck(:id)

    array = []

    sql = "select date_part('week',sp.created_at) as week, date_part('year', sp.created_at) as year, count(*) as performances 
    	from student_performances sp
    	inner join student_users s on s.id = sp.student_user_id and s.id not in (?)  
    	group by date_part('week',sp.created_at), date_part('year', sp.created_at) 
    	order by date_part('year',sp.created_at) ASC, date_part('week',sp.created_at) ASC"

    arguments = Array.new
    arguments[0] = sql
    arguments[1] = exclude_student_user_ids
    sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
		counts = ActiveRecord::Base.connection.execute(sanitized_query).to_a

		counts.each do |count|
			puts count["performances"]
			array.push({year: count["year"], week: count["week"], count: count["performances"].to_i})
		end

		return array

  end
	
	# return the cumulative number of performances from "real" Student Users by week
  def self.cumulative_create_count_by_week
    
    array = self.create_count_by_week

    cum = 0
    array.each do |week|
      cum += week[:count]
      week[:count] = cum
    end

    array

  end


end
