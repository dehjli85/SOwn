class StudentPerformanceVerification < ActiveRecord::Base

	validates :classroom_activity_pairing_id, :student_user_id, presence: true
	validates_uniqueness_of :student_user_id, :scope => :classroom_activity_pairing_id

	belongs_to :classroom_activity_pairing
	belongs_to :student_user

end
