class Activity < ActiveRecord::Base

  require 'cgi'

	#has_and_belongs_to_many :classrooms
	belongs_to :teacher_user
  #has_many :activities_classrooms
  has_many :classroom_activity_pairings
  has_many :classrooms, :through => :classroom_activity_pairings
  has_many :activity_tag_pairings
  has_many :activity_tags, :through => :activity_tag_pairings

	validates :activity_type, inclusion: { in: %w(completion scored),
    message: "%{value} is not a valid activity type" }
  validates :name, :teacher_user_id, :activity_type, presence: true
  validates :min_score, numericality: true, :allow_nil => true 
  validates :max_score, numericality: true, :allow_nil => true 
  validates :benchmark1_score, numericality: true, :allow_nil => true 
  validates :benchmark2_score, numericality: true, :allow_nil => true 
  validate :min_less_than_max
  validate :benchmarks_valid

  after_find :set_pretty_properties

  ##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

  def min_less_than_max
    if(!min_score.nil? && !max_score.nil? && min_score >= max_score)
      errors.add(:min_score, 'must be less than max score')
    end
  end

  def benchmarks_valid
    if !benchmark1_score.nil? && (min_score.nil? || max_score.nil?)
      errors.add(:benchmark1_score, 'can only be used if min and max scores are set')
      return
    end
    if !benchmark2_score.nil? && (min_score.nil? || max_score.nil?)
      errors.add(:benchmark2_score, 'can only be used if min and max scores are set')
      return
    end
    if benchmark1_score && (benchmark1_score < min_score || benchmark1_score > max_score)
      errors.add(:benchmark1_score, 'must be between min and max scores')
    end
    if benchmark2_score && (benchmark2_score < min_score || benchmark2_score > max_score)
      errors.add(:benchmark2_score, 'must be between min and max scores')
    end
    if (benchmark1_score && benchmark2_score) && benchmark1_score > benchmark2_score
      errors.add(:benchmark1_score, 'must be less than benchmark 2 score')
    end
  end

  ##################################################################################################
  #
  # Pretty Properties
  #
  ##################################################################################################
  def set_pretty_properties
    
    # activity type
    if activity_type.eql?('scored')
      @activity_type_pretty = 'Scored'
    elsif activity_type.eql?('completion')
      @activity_type_pretty = 'Completed'
    end     

    # description abbreviation
    @description_abbreviated = description[0..25] + (description.length > 26 ? '...' : '')

    # instructions abbreviation    
    @instructions_abbreviated = instructions[0..25] + (instructions.length > 26 ? '...' : '')

  end

  def activity_type_pretty
    @activity_type_pretty
  end

  def description_abbreviated
    @description_abbreviated
  end

  def instructions_abbreviated
    @instructions_abbreviated
  end

  def as_json(options = { })
      # just in case someone says as_json(nil) and bypasses
      # our default...
      super((options || { }).merge({
          :methods => [:description_abbreviated, :instructions_abbreviated, :activity_type_pretty]
      }))
  end


  ##################################################################################################
  #
  # Model API Methods
  #
  ##################################################################################################


end
