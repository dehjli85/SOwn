class ActivityLevel < ActiveRecord::Base
	belongs_to :activity

	validates :name, :activity_id, presence: true
	
	after_find :set_pretty_properties
	##################################################################################################
  #
  # Pretty Properties
  #
  ##################################################################################################
  def set_pretty_properties

    # level abbreviation
    if !name.index(":").nil? && name.index(":") <= 2
    	@name_abbreviated = name[0..[name.index(":")-1, 1].min]
    elsif name.length <=2
      @name_abbreviated = name
  	else
  		@name_abbreviated = ''
  	end

  end

  def name_abbreviated
    @name_abbreviated
  end

  
  def as_json(options = { })
      # just in case someone says as_json(nil) and bypasses
      # our default...
      super((options || { }).merge({
          :methods => [:name_abbreviated]
      }))
  end

end
