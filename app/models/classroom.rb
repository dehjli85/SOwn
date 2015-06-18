class Classroom < ActiveRecord::Base
	belongs_to :teacher_user
	has_and_belongs_to_many :student_users, -> {order 'student_users.last_name, student_users.first_name'}
	#has_and_belongs_to_many :activities
	has_many :classroom_activity_pairings
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

	def get_activities_and_student_performance_data(student_user_id)
		
		activities_array = Array.new(self.activities.size)
		student_performance_array = Array.new

		acs = ClassroomActivityPairing.where({classroom_id: self.id})
		acs.each_with_index do |ac, index|
			#create a sorted array of the activities
			activities_array[index] = {activity: ac.activity, ac_id: ac.id}
			#create a sorted array of all performances
			student_performance_array[index] = StudentPerformance.where({classroom_activity_pairing_id: ac.id, student_user_id: student_user_id}).order("created_at DESC").first
			#create a sorted array of all the activities_classrooms id

		end		

		activities_and_student_performance_hash = Hash.new
		activities_and_student_performance_hash[:activities] = activities_array
		activities_and_student_performance_hash[:student_performance] = student_performance_array

		return activities_and_student_performance_hash

	end




end
