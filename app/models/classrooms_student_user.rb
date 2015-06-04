class ClassroomsStudentUser < ActiveRecord::Base
	belongs_to :classroom
	belongs_to :student_user

	validates :classroom_id, :student_user_id, presence: true
	validates_uniqueness_of :classroom_id, :scope => :student_user_id

end
