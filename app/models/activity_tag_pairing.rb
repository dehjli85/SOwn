class ActivityTagPairing < ActiveRecord::Base
	belongs_to :activity
	belongs_to :activity_tag

	validates_uniqueness_of :activity_tag_id, :scope => :activity_id
	validates :activity_id, :activity_tag_id, presence: true


end
