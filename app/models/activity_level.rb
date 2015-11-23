class ActivityLevel < ActiveRecord::Base
	belongs_to :activity

	validates :abbreviation, :activity_id, presence: true
  validates :abbreviation, length: {maximum: 2}
	
	##################################################################################################
  #
  # Pretty Properties
  #
  ##################################################################################################


end
