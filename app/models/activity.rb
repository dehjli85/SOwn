class Activity < ActiveRecord::Base
	has_and_belongs_to_many :classrooms
	belongs_to :teacher_user

	validates :activity_type, inclusion: { in: %w(completion scored),
    message: "%{value} is not a valid activity type" }
  validates :name, :teacher_user_id, :activity_type, presence: true

  def description_abbreviated
  	description[0..25] + (description.length > 26 ? '...' : '')
  end

  def instructions_abbreviated
  	instructions[0..25] + (instructions.length > 26 ? '...' : '')
  end

  def activity_type_description
  	case activity_type
  	when 'completion'
  		'Completion'
  	when 'scored'
  		'Scored'
  	end
  end
end
