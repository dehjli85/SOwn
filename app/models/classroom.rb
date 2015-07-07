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

	def student_performances

		#create/populate array with classroom activity pairing ids
		pairing_array = Array.new
		self.classroom_activity_pairings.each do |pairing|
			pairing_array.push(pairing.id)
		end

		#store the performances into a hash, where the student is the key
		# the values are another hash, where the key is the activity, and the value is the pairing
		performances_hash = Hash.new
		performances = StudentPerformance.where({classroom_activity_pairing_id: pairing_array})
		performances.each do |p|
			if !performances_hash[p.student_user]
				performances_hash[p.student_user] = Hash.new
			end
			performances_hash[p.student_user][p.activity] = p
		end

		# student_hash = Hash.new
		# self.student_users.each do |student|
		# 	student_hash[student] = performances_hash[student]
		# end

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
