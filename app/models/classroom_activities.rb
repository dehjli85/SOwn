class ClassroomActivities < ActiveRecord::Base
	belongs_to :classroom
	belongs_to :activity

	validates :classroom_id, :activity_id, presence: true
	validates_uniqueness_of :classroom_id, :scope => :activity_id

end
