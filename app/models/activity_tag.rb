class ActivityTag < ActiveRecord::Base
	has_many :activity_tag_parings
	has_many :activities, :through => :activity_tag_pairings

	validates :name, presence: true
	validates :name, uniqueness: true
	validates :name, format: { without: /\s/ }

	def name=(name)
		if !name.nil? && name[0].eql?('#')
			write_attribute(:name, name[1..name.length])			
		else
			write_attribute(:name, name)			
		end
	end

	def hashed_name
		'#' + name
	end
end
