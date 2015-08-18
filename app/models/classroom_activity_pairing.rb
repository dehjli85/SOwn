class ClassroomActivityPairing < ActiveRecord::Base

	belongs_to :classroom
	belongs_to :activity, -> {order 'activities.created_at ASC'}
	has_many :student_performances, -> {order 'student_performances.created_at ASC'}
	has_many :student_performance_verifications
	

	validates :classroom_id, :activity_id, :sort_order, presence: true
	validates :classroom_id, :activity_id, presence: true
	validates_uniqueness_of :classroom_id, :scope => :activity_id

	def self.max_sort_order(classroom_id)

		ClassroomActivityPairing.where({classroom_id: classroom_id}).pluck(:sort_order).max
		
	end
end
