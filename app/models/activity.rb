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

  def description_abbreviated
  	description[0..25] + (description.length > 26 ? '...' : '')
  end

  def instructions_abbreviated
  	instructions[0..25] + (instructions.length > 26 ? '...' : '')
  end

  def activity_type_description
  	case activity_type
  	when 'completion'
  		'Completion'
  	when 'scored'
  		'Scored'
  	end
  end

  def activity_tags_to_js_array
    a = Array.new
    self.activity_tags.each do |at|
      a.push(at.name)
    end
    return a.to_s.html_safe
  end

  def search_match(search_term)    
    if search_term.nil? || name.downcase.include?(search_term.downcase) || description.downcase.include?(search_term.downcase)
      return true
    end
    self.activity_tags.each do |tag|
      if tag.name.downcase.include?(search_term.downcase)
        return true
      end
    end
    return false
  end

  def tag_match(tag)
    if tag.nil?
      return true
    end
    self.activity_tags.each do |t|
      if t.name.downcase.eql?(tag.downcase)
        return true
      end
    end
    return false
  end

end
