class Classroom < ActiveRecord::Base
	belongs_to :teacher_user
	# has_and_belongs_to_many :student_users, -> {order 'student_users.last_name, student_users.first_name'}
  has_many :student_users, :through => :classroom_student_users

	#has_and_belongs_to_many :activities
	has_many :classroom_activity_pairings, -> {order 'classroom_activity_pairings.created_at ASC'}
	has_many :activities, :through => :classroom_activity_pairings
	has_many :classroom_student_users

	validates :classroom_code, :name, :teacher_user_id, presence: true
	validates :classroom_code, uniqueness: true
	validates :classroom_code, length: { maximum: 100 }
	validate :classroom_code_in_valid_format

	##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

	def classroom_code_in_valid_format
		if (/^(\d|[a-zA-Z]|-)+$/ =~ classroom_code).nil?
			errors.add(:classroom_code, "can only contain letters, numbers and dashes (-).")
		end

	end

	##################################################################################################
  #
  # Model API Methods
  #
  ##################################################################################################

  # Returns array of activities with classroom_activity_pairing_id and sort order for each activity
  # includeHidden can be passed to indicate whether hidden activities should be returned (default is false)
  def activities_with_pairing_ids(includeHidden=false)
  	if includeHidden
  		Activity.joins("inner join classroom_activity_pairings cap on cap.activity_id = activities.id")
        .joins("inner join classrooms c on c.id = cap.classroom_id")
        .where("c.id = ?", self.id)
        .order("cap.sort_order ASC")
        .select("activities.*, cap.id as classroom_activity_pairing_id, cap.sort_order")
    else
    	Activity.joins("inner join classroom_activity_pairings cap on cap.activity_id = activities.id")
	      .joins("inner join classrooms c on c.id = cap.classroom_id")
	      .where("c.id = ?", self.id)
	      .where("cap.hidden = false")
	      .order("cap.sort_order ASC")
	      .select("activities.*, cap.id as classroom_activity_pairing_id, cap.sort_order")
    end

  end

  # Returns an Array of Student Performances in the classroom for the specified student.  
  # Includes the activity_id, sort_order, and boolean for requires verification
  # includeHidden can be passed to indicate whether hidden activities should be returned (default is false)  
  def student_performances_for_student(student_user_id, includeHidden=false)

    cap_ids = self.classroom_activity_pairings.pluck(:id)

		if(includeHidden)
	  	StudentPerformance.joins(:classroom_activity_pairing)
        .joins("left join student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id")
        .where(classroom_activity_pairing_id: cap_ids)
        .where(student_user_id: student_user_id)
        .order("created_at DESC")
        .select("student_performances.*, classroom_activity_pairings.activity_id, classroom_activity_pairings.sort_order", "spv.id is not null as requires_verification")
    else
    	StudentPerformance.joins(:classroom_activity_pairing)
        .joins("left join student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id")
        .where(classroom_activity_pairing_id: cap_ids)
        .where(student_user_id: student_user_id)
        .where("classroom_activity_pairings.hidden = false")
        .order("created_at DESC")
        .select("student_performances.*, classroom_activity_pairings.activity_id, classroom_activity_pairings.sort_order", "spv.id is not null as requires_verification")
      end

  end

  # Returns a hash with keys "activities" and "student_performances"
  # Value for "activities" key is an array of activities with classroom_activity_pairing_id and sort order for each activity 
  # Value for "student_performances" key is an array of student_performances.  Each object in the array also includes activity_information and student name and id
	def search_matched_pairings_and_activities(search_hash={search_term: nil, tag_id: nil })

		tag_hash = Hash.new
		
		# if there's no search term provided, just use active record relationship
		if (search_hash[:search_term].nil? || search_hash[:search_term].eql?('')) && search_hash[:tag_id].nil?

			activities = self.activities_with_pairing_ids(true)

			sql = 'SELECT spv.student_user_id is not null as requires_verification, student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, student_performances.* 
			FROM "student_performances" 
			INNER JOIN "student_users" ON "student_users"."id" = "student_performances"."student_user_id" 
			INNER JOIN "classroom_student_users" ON "classroom_student_users"."student_user_id" = "student_users"."id" and "classroom_student_users"."classroom_id" = ?
			INNER JOIN "classroom_activity_pairings" ON "classroom_activity_pairings"."id" = "student_performances"."classroom_activity_pairing_id" 
			INNER JOIN activities a on a.id =  classroom_activity_pairings.activity_id 
			LEFT OUTER JOIN student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id and student_users.id = spv.student_user_id 
			WHERE (classroom_activity_pairings.classroom_id = ?)  ORDER BY student_users.last_name ASC'

			sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, id, id])

			student_performances = ActiveRecord::Base.connection.execute(sanitized_query)

			return {activities: activities, student_performances: student_performances}

		else
			
			#if the user has provided a space-separated list of tags
			if(!(search_hash[:search_term].nil? || search_hash[:search_term].eql?('')) && search_hash[:search_term][0].eql?('#'))

				#create an array with the tags
				tag_array = search_hash[:search_term].gsub('#','').split(/ +/)

				activities = Activity.joins(:classroom_activity_pairings)
					.joins(:activity_tags)
					.where("activity_tags.name" => tag_array)
					.where("classroom_activity_pairings.classroom_id = ?", self.id)
					.select("activities.*, classroom_activity_pairings.sort_order, classroom_activity_pairings.id as classroom_activity_pairing_id")
					.order('classroom_activity_pairings.sort_order ASC')


				sql = 'SELECT spv.student_user_id is not null as requires_verification, student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, student_performances.* 
					FROM "student_performances" 
					INNER JOIN "student_users" ON "student_users"."id" = "student_performances"."student_user_id" 
					INNER JOIN "classroom_student_users" ON "classroom_student_users"."student_user_id" = "student_users"."id" and "classroom_student_users"."classroom_id" = ?
					INNER JOIN "classroom_activity_pairings" ON "classroom_activity_pairings"."id" = "student_performances"."classroom_activity_pairing_id" 
					INNER JOIN activities a on a.id =  classroom_activity_pairings.activity_id 
					LEFT JOIN activity_tag_pairings atp on atp.activity_id = a.id
					LEFT JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.name in (?)
					LEFT OUTER JOIN student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id and student_users.id = spv.student_user_id 
					WHERE (classroom_activity_pairings.classroom_id = ?)  
					ORDER BY student_users.last_name ASC'
				sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, id, tag_array,id])
				student_performances = ActiveRecord::Base.connection.execute(sanitized_query)


				return {activities: activities, student_performances: student_performances}

				
			elsif search_hash[:search_term]			

				activities = Activity.joins(:classroom_activity_pairings)				
				.joins("LEFT JOIN activity_tag_pairings tag_pairings on classroom_activity_pairings.activity_id = tag_pairings.activity_id")
				.joins("LEFT JOIN activity_tags tags on tag_pairings.activity_tag_id = tags.id")
				.where("lower(tags.name) like ? or lower(activities.name) like ? or lower(activities.description) like ?" , "%#{search_hash[:search_term].downcase}%", "%#{search_hash[:search_term].downcase}%", "%#{search_hash[:search_term].downcase}%")
				.where("classroom_activity_pairings.classroom_id = ?", self.id)
				.select("activities.*, classroom_activity_pairings.sort_order, classroom_activity_pairings.id as classroom_activity_pairing_id")
				.order('classroom_activity_pairings.sort_order ASC')
				.distinct

				sql = 'SELECT spv.student_user_id is not null as requires_verification, student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, student_performances.* 
					FROM "student_performances" 
					INNER JOIN "student_users" ON "student_users"."id" = "student_performances"."student_user_id" 
					INNER JOIN "classroom_student_users" ON "classroom_student_users"."student_user_id" = "student_users"."id" and "classroom_student_users"."classroom_id" = ?
					INNER JOIN "classroom_activity_pairings" ON "classroom_activity_pairings"."id" = "student_performances"."classroom_activity_pairing_id" 
					INNER JOIN activities a on a.id =  classroom_activity_pairings.activity_id 
					LEFT JOIN activity_tag_pairings atp on atp.activity_id = a.id
					LEFT JOIN activity_tags tags on tags.id = atp.activity_tag_id 
					LEFT OUTER JOIN student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id and student_users.id = spv.student_user_id 
					WHERE (classroom_activity_pairings.classroom_id = ?)  
						AND (lower(tags.name) like ? or lower(a.name) like ? or lower(a.description) like ?)
					ORDER BY student_users.last_name ASC'
				sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, id, id, "%#{search_hash[:search_term].downcase}%", "%#{search_hash[:search_term].downcase}%", "%#{search_hash[:search_term].downcase}%" ])
				student_performances = ActiveRecord::Base.connection.execute(sanitized_query)

				return {activities: activities, student_performances: student_performances}

			elsif search_hash[:tag_id]

				activities = Activity.joins(:classroom_activity_pairings)
				.joins(:activity_tags)
				.where("activity_tags.id = ?", search_hash[:tag_id])
				.where("classroom_activity_pairings.classroom_id = ?", self.id)
				.select("activities.*, classroom_activity_pairings.sort_order, classroom_activity_pairings.id as classroom_activity_pairing_id")
				.order('classroom_activity_pairings.sort_order ASC')


				sql = 'SELECT spv.student_user_id is not null as requires_verification, student_users.id as student_user_id, student_users.display_name as student_display_name, student_users.last_name as student_last_name, a.name as activity_name, a.id as activity_id, a.activity_type, a.benchmark1_score, a.benchmark2_score, a.max_score, a.min_score, student_performances.* 
					FROM "student_performances" 
					INNER JOIN "student_users" ON "student_users"."id" = "student_performances"."student_user_id" 
					INNER JOIN "classroom_student_users" ON "classroom_student_users"."student_user_id" = "student_users"."id" and "classroom_student_users"."classroom_id" = ?
					INNER JOIN "classroom_activity_pairings" ON "classroom_activity_pairings"."id" = "student_performances"."classroom_activity_pairing_id" 
					INNER JOIN activities a on a.id =  classroom_activity_pairings.activity_id 
					INNER JOIN activity_tag_pairings atp on atp.activity_id = a.id
					INNER JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.id = ?
					LEFT OUTER JOIN student_performance_verifications spv on classroom_activity_pairings.id = spv.classroom_activity_pairing_id and student_users.id = spv.student_user_id 
					WHERE (classroom_activity_pairings.classroom_id = ?)  
					ORDER BY student_users.last_name ASC'
				sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, id, search_hash[:tag_id],id])
				student_performances = ActiveRecord::Base.connection.execute(sanitized_query)

				return {activities: activities, student_performances: student_performances}

			end				

		end

	end


	# Returns and array of Classroom Activity Pairings that match the search_term or search tag
	def search_matched_pairings(search_hash={search_term: nil, search_tag: nil })

		tag_hash = Hash.new
		
		# if there's no search term provided, just use active record relationship
		if search_hash[:search_term].nil? && search_hash[:search_tag].nil?

			return self.classroom_activity_pairings

		else
			
			#if the user has provided a space-separated list of tags
			if(search_hash[:search_term] && search_hash[:search_term][0].eql?('#'))

				#create an array with the tags
				tag_array = search_hash[:search_term].gsub('#','').split(/ +/)

				#get the ids of the tags
				activity_tag_id_array = ActivityTag.where({name: tag_array}).ids

				#get the activity ids that use said tags
				activity_id_array = ActivityTagPairing.where({activity_tag_id: activity_tag_id_array}).pluck(:activity_id)

				#get the classroom activity pairings for those activities and the classroom
				caps = ClassroomActivityPairing.where({activity_id: activity_id_array, classroom_id: self.id})

				return caps

			#the user has provided a general search or is searching for a particular tag	
			else				

				activity_id_array = Array.new

				if search_hash[:search_term]

					#get ids of tags where the name contains the search term
					activity_tag_id_array = ActivityTag.where( "name like ?" , "%#{search_hash[:search_term].downcase}%").ids

					#get the ids of the activities that have the tags from above and add them to the activity_id array
					activity_id_array.concat(ActivityTagPairing.where({activity_tag_id: activity_tag_id_array}).pluck(:activity_id))					

					#get the ids of activities where the name/description contains the search term and add them to the activity_id array
					activity_id_array.concat(Activity.where( "name like ? or description like ?" , "%#{search_hash[:search_term].downcase}%", "%#{search_hash[:search_term].downcase}%").ids)					

				end

				if search_hash[:search_tag]

					#find tag that is being searched for
					activity_tag = ActivityTag.find_by_name(search_hash[:search_tag])

					#if it exists, get all the ids of the activities with that tag and add them to the activity_id array
					if activity_tag
						activity_id_array.concat(ActivityTagPairing.where({activity_tag_id: activity_tag}).pluck(:activity_id))
					end

				end

				#get the classroom activity pairings that match the classroom id and the activity ids from the created array
				caps = ClassroomActivityPairing.where({activity_id: activity_id_array, classroom_id: self.id})

				return caps

			end		

		end

	end

	# Returns an array of the distinct Tags for Activities in the Classroom matching search_term or search_tag
	def search_matched_tags(search_hash={search_term: nil, search_tag: nil })

		activity_ids = self.search_matched_pairings(search_hash).pluck(:activity_id)		

		activity_tag_ids = ActivityTagPairing.where(activity_id: activity_ids).pluck(:activity_tag_id)

		return ActivityTag.where(id: activity_tag_ids)

	end

	# Returns an array of distinct Tags for Activities in the Classroom
	def tags
		
		tag_hash = Hash.new

		#Get all the activities ids for the classroom and put them into an array
		activity_id_array = self.classroom_activity_pairings.pluck(:activity_id)

		#get all the tag id's from the pairings
		tag_id_array = ActivityTagPairing.where({activity_id: activity_id_array}).pluck(:activity_tag_id)

		#query for the activity tags corresponding to the tag id's, and put them into a hash to make them unique
		activity_tags = ActivityTag.where(id: tag_id_array).order("name ASC").distinct

		return activity_tags
		
	end

	# Returns a Hash with 2 keys: :activities and :student_performances for the specified student_user_id  
	# Value for :activities is an Array of Hashes.  Each Hash in the Array has 2 keys: :activity and :cap_id
	# => Value for :activity is the Activity
	# => Value for cap_id, value is the id of the Classroom Activity Pairing associated with that Activity and this Classroom
	# Value for :student_performances is an Array of Student Performances, with the most recent performances coming first
	#
	# The performances are sorted in the same order as the activities.
	def get_activities_and_student_performance_data(student_user_id)
		
		activities_array = Array.new(self.activities.size)
		student_performance_array = Array.new

		caps = ClassroomActivityPairing.where({classroom_id: self.id})
		caps.each_with_index do |cap, index|

			#create a sorted array of the activities
			activities_array[index] = {activity: cap.activity, cap_id: cap.id}

			#create a sorted array of all performances			
			student_performance_array[index] = StudentPerformance.where({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id}).order("id DESC")

		end		

		activities_and_student_performance_hash = Hash.new
		activities_and_student_performance_hash[:activities] = activities_array
		activities_and_student_performance_hash[:student_performances] = student_performance_array

		return activities_and_student_performance_hash

	end

	# Returns a Float indicating the percentage of Activities completed by Student Users in the Classroom at a proficient level
	# Proficient level is:
	# => Completed for completion Activity
	# => Greater than the max of Benchmark1 and Benchmark2 of the scored Activity
	def percent_proficient_activities
		
		students = self.student_users
		cap_ids = self.search_matched_pairings.joins(:activity)
			.where("(activity_type = 'completion') or (activity_type = 'scored' and (benchmark1_score is not null or benchmark2_score is not null))")
			.ids

		total_activities = students.length * cap_ids.length
		
		student_performances = StudentPerformance.joins(:activity)
			.joins(:classroom_activity_pairing)
			.where({classroom_activity_pairing_id: cap_ids})
			.where('completed_performance= true or scored_performance > greatest(benchmark1_score, benchmark2_score)')
			.where(:student_user_id => students.pluck(:id))

		proficient_count = student_performances.length

		if total_activities == 0
			return 0.0
		elsif proficient_count > 0
			return proficient_count.to_f / total_activities.to_f
		else
			return 0.0
		end

	end

	# Returns a Float indicating the percentage of Activities completed by the specified Student User in the Classroom at a proficient level
	# Proficient level is:
	# => Completed for completion Activity
	# => Greater than the max of Benchmark1 and Benchmark2 of the scored Activity
	def percent_proficient_activities_student(student_user_id)
		
		cap_ids = self.search_matched_pairings.joins(:activity).where("(activity_type = 'completion') or (activity_type = 'scored' and (benchmark1_score is not null or benchmark2_score is not null))").ids

		total_activities = cap_ids.length
		
		student_performances = StudentPerformance.joins(:activity)
			.where({classroom_activity_pairing_id: cap_ids})
			.where('completed_performance= true or scored_performance > greatest(benchmark1_score, benchmark2_score)')
			.where(student_user_id: student_user_id)
		
		proficient_count = student_performances.length
		
		if total_activities == 0
			return 0.0
		elsif proficient_count > 0
			return proficient_count.to_f / total_activities.to_f
		else
			return 0.0
		end

	end


	# Returns and Array of Hashes.  
	# Each Hash represents an Activity. In addition to having keys representing all the Activity fields, there is also a "student performances" key
	# The value of the "student performances" key is an Array of all the Student Performances entered by the Student User for that Activity in the Classroom
	# Activities hidden from the Student User are excluded
	def activities_and_performances(student_user_id)

		unsorted_activities = self.activities_with_pairing_ids.as_json
		
		# Sort activities based on their sort order		
		# There are potentially null objects in the sorted array based on what the teacher has hidden
		sorted_activities = Array.new
    unsorted_activities.each do |activity|
      activity["student_performances"] = Array.new
      sorted_activities[activity["sort_order"]] = activity
    end

    # Get all Student Performances for the Student User in the Classroom (excluding hidden Activities)
    performances_array = self.student_performances_for_student(student_user_id).as_json
    performances_array.each do |performance|

      sort_order = performance["sort_order"]

      performance["performance_pretty"] = 
      	StudentPerformance.performance_pretty_no_active_record(
      		activities[sort_order]["activity_type"], 
      		performance["scored_performance"], 
      		performance["completed_performance"]
    		)
      performance["performance_color"] = 
      	StudentPerformance.performance_color_no_active_record(
      		activities[sort_order]["activity_type"], 
      		activities[sort_order]["benchmark1_score"], 
      		activities[sort_order]["benchmark2_score"], 
      		activities[sort_order]["min_score"], 
      		activities[sort_order]["max_score"], 
      		performance["scored_performance"], 
      		performance["completed_performance"]
      	)

      if sorted_activities[sort_order]["student_performances"].nil?
        sorted_activities[sort_order]["student_performances"] = Array.new
      end
      sorted_activities[sort_order]["student_performances"].push(performance)

    end

    # Remove nil objects from the sorted array
    sorted_activities.reject! do |activity| 
    	activity.nil? 
    end

    return sorted_activities

	end


end
