class ActivityLevel < ActiveRecord::Base
	belongs_to :activity

	validates :name, :activity_id, presence: true

end
