class Activity < ActiveRecord::Base
	#has_and_belongs_to_many :classrooms
	belongs_to :teacher_user
  #has_many :activities_classrooms
  has_many :classroom_activity_pairings
  has_many :classrooms, :through => :classroom_activity_pairings

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
