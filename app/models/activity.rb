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
  
  # Returns SQL Result object representing Activities assigned the Classroom with id = classroomId
  # In addition to all activity fields, all objects in Result also include the Classroom Activity Pairing id and sort_order fields
  # If an invalid classroomId (i.e. Classroom doesn't exist) is passed, returns nil
  #
  # Uses:
  #  searchTerm: if the first character is a '#', all '#'s are removed from the string, and it is treated as a space separated list of tags.  Returns only Activities with one or more of the tags in the list
  #                 EXAMPLES: "#tag1 #tag2" => ('tag1', 'tag2').  "#tag1#tag2" => ('tag1tag2').  "#tag1 tag2" => ('tag1',' tag2')
  #              if the first character is not a '#', returns Activities that have a name, description, or Tag name containing the string (case insensitive)
  #  tagId: returns Activities that have been tagged with the Activity Tag with id = tagId
  #  includeHidden: boolean argument that determines whether Activities assigned to Classrooms but are hidden should be returned.  Method by default returns all Activities.
  #
  # WARNING: searchTerm and tagId cannot be used together.  If both are passed to the method, searchTerm will be used and tagId will be ignored

  def self.activities_with_pairings_ids(classroomId, searchTerm=nil, tagId=nil, includeHidden=true)

    if Classroom.where(id: classroomId).empty?
      return nil
    end

    if(!(searchTerm.nil? || searchTerm.eql?('')) && searchTerm[0].eql?('#'))
      tag_array = searchTerm.gsub('#','').split(/ +/)
    else
      tag_array = nil
    end

    arguments = [nil]

    sql = 'SELECT distinct a.*, 
            cap.id as classroom_activity_pairing_id, cap.sort_order
          FROM activities a 
          INNER JOIN "classroom_activity_pairings" cap on cap.activity_id = a.id 
          LEFT JOIN activity_tag_pairings atp on atp.activity_id = a.id'
    
    if !tag_array.nil?
      sql += ' LEFT JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.name in (?)'
      arguments.push(tag_array)
    elsif searchTerm
      sql += ' LEFT JOIN activity_tags tags on tags.id = atp.activity_tag_id' 
    elsif tagId
      sql += ' INNER JOIN activity_tags tags on tags.id = atp.activity_tag_id and tags.id = ?'
      arguments.push(tagId)
    end

    sql += ' WHERE (cap.classroom_id = ?)'
    arguments.push(classroomId)

    if !includeHidden
      sql += ' AND cap.hidden = false'
    end

    if tag_array
      sql += ' AND tags.name in (?)'
      arguments.push(tag_array)
    elsif searchTerm && tag_array.nil?
      sql += ' AND (lower(tags.name) like ? or lower(a.name) like ? or lower(a.description) like ?)'      
      arguments.push("%#{searchTerm.downcase}%")      
      arguments.push("%#{searchTerm.downcase}%")      
      arguments.push("%#{searchTerm.downcase}%")      
    end    

    sql += ' ORDER BY a.created_at DESC'    
    arguments[0] = sql

    sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
    activities = ActiveRecord::Base.connection.execute(sanitized_query)

  end

end
