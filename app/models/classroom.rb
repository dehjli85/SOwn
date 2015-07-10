class Classroom < ActiveRecord::Base
	belongs_to :teacher_user
	has_and_belongs_to_many :student_users, -> {order 'student_users.last_name, student_users.first_name'}
	#has_and_belongs_to_many :activities
	has_many :classroom_activity_pairings, -> {order 'created_at ASC'}
	has_many :activities, :through => :classroom_activity_pairings

	validates :classroom_code, :name, :teacher_user_id, presence: true
	validates :classroom_code, uniqueness: true
	validates :classroom_code, length: { maximum: 100 }
	validate :classroom_code_in_valid_format

	def classroom_code_in_valid_format
		if (/^(\d|[a-zA-Z]|-)+$/ =~ classroom_code).nil?
			errors.add(:classroom_code, "can only contain letters, numbers and dashes (-).")
		end

	end


	# return classroom pairing objects that match the search_term
	# this method has been optimized to minimize the number of database calls made
	# it, therefore, doesn't take advantage of all the active record features
	def search_matched_pairings(search_hash={search_term: nil, search_tag: nil })

		start_time = Time.now
		tag_hash = Hash.new
		
		# if there's no search term provided, just use active record relationship
		if search_hash[:search_term].nil? && search_hash[:search_tag].nil?

			end_time = Time.now
			puts "search_matched_pairings2 run time: #{end_time-start_time}"

			return self.classroom_activity_pairings

		else
			
			#if the user has provided a space-separated list of tags
			if(search_hash[:search_term] && search_hash[:search_term][0].eql?('#'))

				tag_array = search_hash.gsub('#','').split(/ +/)

				activity_tag_id_array = Array.new
				activity_tags = ActivityTag.where({name: tag_array})
				activity_tags.each do |tag|
					activity_tag_id_array.push(tag.id)
				end

				activity_tag_pairings = ActivityTagPairing.where({activity_tag_id: activity_tag_id_array})
				activity_id_array = Array.new
				activity_tag_pairings.each do |pairing|
					activity_id_array.push(pairing.activity_id)
				end

				caps = ClassroomActivityPairing.where({activity_id: activity_id_array, classroom_id: self.id})

				end_time = Time.now
				puts "search_matched_pairings2 run time: #{end_time-start_time}"

				return caps

			#the user has provided a general search or is searching for a particular tag	
			else				

				activity_id_array = Array.new

				if search_hash[:search_term]
					# get all the tags which have the search term present in the name		
					activity_tag_id_array = Array.new
					activity_tag_matches = ActivityTag.where( "name like '%?%'" , search_hash[:search_term].downcase)				
					activity_tags.each do |tag|
						activity_tag_id_array.push(tag.id)
					end

					#get the pairings for the tags obtained above, store the activity ids into an array
					activity_tag_pairings = ActivityTagPairing.where({activity_tag_id: activity_tag_id_array})
					
					activity_tag_pairings.each do |pairing|
						activity_id_array.push(pairing.activity_id)
					end

					#get the activities which have the search term present in the description or the name
					#add id's of said activities into the array from above
					activity_matches = Activity.where( "name like '%?%' or description like '%?%'" , search_hash[:search_term].downcase, search_hash[:search_term].downcase) 
					activity_matches.each do |activity_match|
						activity_id_array.push(activity_match.id)
					end

				end

				if search_hash[:search_tag]
					activity_tag = ActivityTag.find_by_name(search_hash[:search_tag])

					if activity_tag
						activity_tag_pairings = ActivityTagPairing.where({activity_tag_id: activity_tag})

						activity_tag_pairings.each do |pairing|
							activity_id_array.push(pairing.activity_id)
						end
					end

				end

				#get the classroom activity pairings that match the classroom id and the activity ids from the created array
				caps = ClassroomActivityPairing.where({activity_id: activity_id_array, classroom_id: self.id})

				end_time = Time.now
				puts "search_matched_pairings2 run time: #{end_time-start_time}"

				return caps

			end		

		end

	end

	#return an array of the distinct tags for activities inthe classroom
	def search_matched_tags(search_hash={search_term: nil, search_tag: nil })

		pairings = self.search_matched_pairings(search_hash)		

		tag_hash = Hash.new
		pairings.each do |pairing|
			pairing.activity.activity_tags.each do |tag|
				tag_hash[tag.id] = tag
			end
		end

		return tag_hash
	end

	def tags
		
		start_time = Time.now

		tag_hash = Hash.new

		#Get all the activities ids for the classroom and put them into an array
		caps = self.classroom_activity_pairings
		activity_id_array = Array.new
		caps.each do |cap|
			activity_id_array.push(cap.activity_id)
		end

		#query for activity tag pairings with the activity ids
		activity_tag_pairings = ActivityTagPairing.where({activity_id: activity_id_array})

		#get all the tag id's from the pairings
		tag_id_array = Array.new
		activity_tag_pairings.each do |tag_pairing|
			tag_id_array.push(tag_pairing.activity_tag_id)
		end

		#query for the activity tags corresponding to the tag id's, and put them into a hash to make them unique
		activity_tags = ActivityTag.where(id: tag_id_array)

		activity_tags.each do |tag|
			tag_hash[tag.id] = tag
		end

		end_time = Time.now
		puts end_time-start_time

		return tag_hash
		
	end

	# returns a hash of hashes.  
	# the key the first layer of the hash is the student, the value is another hash
	# => the key for the second layer of the hash is an activity, 
	# => the value is the student's performance (from the key of the first layer) on that activity
	def student_performances(search_hash={search_term: nil, search_tag: nil })

		start_time = Time.now

		#get the pairings that match the search hash
		#store the pairing ids and activity ids into separate arrays		
		pairings = search_matched_pairings(search_hash)
		pairing_id_array = Array.new
		activity_id_array = Array.new
		pairings.each do |pairing|
			pairing_id_array.push(pairing.id)
			activity_id_array.push(pairing.activity_id)
		end

		#store the performances into a hash, where the student is the key
		# the values are another hash, where the key is the activity, and the value is the pairing		
		performances = StudentPerformance.where({classroom_activity_pairing_id: pairing_id_array})

		#get the students for the classroom and store them in a hash where the key is the id
		students = self.student_users
		students_hash = Hash.new
		students.each do |student|
			students_hash[student.id] = student
		end

		#get the activities for the classroom and store them in a hash where the key is the id
		activities = Activity.where(id: activity_id_array)
		activities_hash = Hash.new
		activities.each do |activity|
			activities_hash[activity.id] = activity
		end

		#get the pairings for the classroom and store them in a hash where the key is the id and the object is the activity
		caps = ClassroomActivityPairing.where(id: pairing_id_array)
		cap_activities_hash = Hash.new
		caps.each do |cap|
			cap_activities_hash[cap.id] = activities_hash[cap.activity_id]
		end
		puts cap_activities_hash
		
		performances_hash = Hash.new
		performances.each do |p|
		
			if !performances_hash[students_hash[p.student_user_id]]
				performances_hash[students_hash[p.student_user_id]] = Hash.new
			end
			performances_hash[students_hash[p.student_user_id]][cap_activities_hash[p.classroom_activity_pairing_id]] = p
		
		end	

		end_time = Time.now
		puts "student_performances runtime: #{end_time-start_time}"

		return performances_hash
		
	end

	def get_activities_and_student_performance_data_all
		
		activities_array = Array.new(self.activities.size)
		student_performances_array = Array.new

		acs = ClassroomActivityPairing.where({classroom_id: self.id})
		acs.each_with_index do |ac, index|
			#create a sorted array of the activities
			activities_array[index] = {activity: ac.activity, ac_id: ac.id}
			#create a sorted array of all performances
			student_performances_array[index]= ac.student_performances
			#create a sorted array of all the activities_classrooms id

		end
		
		#create an empty array for students to store their performance data
		student_performances = Array.new(self.student_users.size)

		#for each student
		self.student_users.each_with_index do |s, index_j|
			
			#create an empty array for their performance on each activity
			individual_performance_array = Array.new(activities_array.size)

			#for each activity
			student_performances_array.each_with_index do |sp, index|
				#check go through all the performances and look to see if the student has one
				sp.each do |p|
					#if the student matches, add the performance to their array
					if p.student_user.id == s.id
						individual_performance_array[index] = p				
					end
				end
			end

			student_performances[index_j] = {student: s, performance_array: individual_performance_array}

		end

		activities_and_student_performance_hash = Hash.new
		activities_and_student_performance_hash[:activities] = activities_array
		activities_and_student_performance_hash[:student_performances] = student_performances

		return activities_and_student_performance_hash

	end

	# Returns a 2 element hash for the specified student.  
	# First key of hash = :activities, value is an array of hashes.  For each hash in the array:
	# => First key of hash = :activity, value is the activity model object
	# => Second key of the hash = cap_id, value is the id of the ClassroomActivityPairing associated with that activity and this classroom
	# Second key of the hash = :student_performance, value is an array of an array of StudentPerformances, with the most recent performances coming first
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
			student_performance_array[index] = StudentPerformance.where({classroom_activity_pairing_id: cap.id, student_user_id: student_user_id}).order("created_at DESC")
			

		end		

		activities_and_student_performance_hash = Hash.new
		activities_and_student_performance_hash[:activities] = activities_array
		activities_and_student_performance_hash[:student_performances] = student_performance_array

		return activities_and_student_performance_hash

	end



end
