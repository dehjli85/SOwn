class ActivityGoal < ActiveRecord::Base

	belongs_to :student_user
	belongs_to :classroom_activity_pairing

  after_find :set_pretty_properties

  validate :has_required_fields

  ##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

	def has_required_fields
		
		activity = self.classroom_activity_pairing.activity

		if activity.activity_type.eql?("scored")
			if score_goal.nil?
				errors.add(:score_goal, "cannot be empty for a scored activity")
			elsif activity.max_score && score_goal > activity.max_score 
				errors.add(:score_goal, "cannot be greater than the max score")
			elsif activity.min_score && score_goal < activity.min_score 
				errors.add(:score_goal, "cannot be less than the min score")
			end
		end

		if activity.activity_type.eql?("completion")
			if goal_date.nil?
				errors.add(:due_date, "cannot be empty for a completion activity")
			end
		end


	end

	##################################################################################################
  #
  # Pretty Properties
  #
  ##################################################################################################

  def set_pretty_properties
    
    # goal_met
    performances = StudentPerformance.where({student_user_id: self.student_user_id, classroom_activity_pairing_id: self.classroom_activity_pairing})
    if self.classroom_activity_pairing.activity.activity_type.eql?("scored")

    	@goal_met = false
    	if(!performances.empty?)
	    	performances.each do |performance|
	    		if performance.scored_performance >= score_goal && (goal_date.nil? || performance.performance_date <= goal_date)
	    			@goal_met = @goal_met || true
	    		end
	    	end
	    end

    elsif self.classroom_activity_pairing.activity.activity_type.eql?("completion")

    	@goal_met = false
    	if(!performances.empty?)
		  	performances.each do |performance|
		  		puts "#{performance.completed_performance}, #{performance.performance_date}, #{goal_date}"
		  		if performance.completed_performance && performance.performance_date <= goal_date
		  			@goal_met = @goal_met || true
		  		end
		  	end
    	end
    end

  
  end


  def goal_met
  	@goal_met
  end

  def as_json(options = { })
      # just in case someone says as_json(nil) and bypasses
      # our default...
      super((options || { }).merge({
          :methods => [:goal_met]
      }))
  end


  ##################################################################################################
  #
  # Model API Methods
  #
  ##################################################################################################

  def self.student_goals(classroomId, searchTerm=nil, tagIds=nil, studentUserId=nil, includeHidden=true, includeArchived=true)

  	if Classroom.where(id: classroomId).empty?
      return nil
    end
    
		if(!(searchTerm.nil? || searchTerm.eql?('')) && searchTerm[0].eql?('#'))
			tag_array = searchTerm.gsub('#','').split(/ +/)
		else
			tag_array = nil
		end

		arguments = [nil, classroomId]
		
		sql = 'SELECT distinct  
						student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, 
						a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, 
						classroom_activity_pairings.sort_order, classroom_activity_pairings.hidden, classroom_activity_pairings.due_date, 
						activity_goals.*
					FROM "activity_goals" 
					INNER JOIN "student_users" ON "student_users"."id" = "activity_goals"."student_user_id" 
					INNER JOIN "classroom_student_users" ON "classroom_student_users"."student_user_id" = "student_users"."id" and "classroom_student_users"."classroom_id" = ?
					INNER JOIN "classroom_activity_pairings" ON "classroom_activity_pairings"."id" = "activity_goals"."classroom_activity_pairing_id" 
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

		sql	+= ' ORDER BY activity_goals.id DESC'		

		arguments[0] = sql

		sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
		activity_goals = ActiveRecord::Base.connection.execute(sanitized_query).to_a

    return activity_goals


  end

  def self.goal_met(activity_goal_id)
  	activity_goal = ActivityGoal.find(activity_goal_id)
  	activity_goal.goal_met
  end

end
