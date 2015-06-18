class ClassroomActivityPairing < ActiveRecord::Base

	belongs_to :classroom
	belongs_to :activity
	has_many :student_performances, -> {order 'student_performances.created_at ASC'}
	

	validates :classroom_id, :activity_id, presence: true
	validates_uniqueness_of :classroom_id, :scope => :activity_id


end
