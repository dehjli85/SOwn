class ActivityGoalReflection < ActiveRecord::Base
	belongs_to :activity_goal
	belongs_to :student_user
	belongs_to :teacher_user

	validate :has_user
	validate :reflection_not_empty
	validates :reflection_date, presence: true

	##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

	def has_user
		
		if !student_user_id && !teacher_user_id
			errors.add(:student_user_id, "must have either a student or teacher assigned to the reflection")
			errors.add(:teacher_user_id, "must have either a student or teacher assigned to the reflection")
		end

	end

	def reflection_not_empty
		if(!reflection || reflection.strip.empty?)
			errors.add(:reflection, "cannot be empty")
		end
	end

	##################################################################################################
  #
  # Pretty Properties
  #
  ##################################################################################################

	def as_json(options = { })
      # just in case someone says as_json(nil) and bypasses
      # our default...
      super((options || { }).merge({
          :methods => [:teacher_user, :student_user]
      }))
  end

end

