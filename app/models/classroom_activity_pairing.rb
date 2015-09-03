class ClassroomActivityPairing < ActiveRecord::Base

	belongs_to :classroom
	belongs_to :activity, -> {order 'activities.created_at ASC'}
	has_many :student_performances, -> {order 'student_performances.created_at ASC'}
	has_many :student_performance_verifications
	

	validates :classroom_id, :activity_id, :sort_order, presence: true
	validates_uniqueness_of :classroom_id, :scope => :activity_id

	# Returns the max sort_order for Activities assigned in the Classroom
	# If there are no activities assigned, it returns nil
	def self.max_sort_order(classroom_id)

		max = ClassroomActivityPairing.where({classroom_id: classroom_id}).pluck(:sort_order).max

		return max
		
	end

	def self.from_hash(hash={})
    
    c = ClassroomActivityPairing.new
    c.id = hash["id"]
    c.activity_id = hash["activity_id"]
    c.classroom_id = hash["classroom_id"]
    c.sort_order = hash["sort_order"]
    c.hidden = hash["hidden"]    
    c.created_at = hash["created_at"]
    c.updated_at = hash["updated_at"]

    return c
  end

  def attributes_eql?(cap)
  	return self.id.eql?(cap.id) && 
  		self.activity_id.eql?(cap.activity_id) && 
  		self.classroom_id.eql?(cap.classroom_id) && 
  		self.sort_order.eql?(cap.sort_order) && 
  		self.hidden.eql?(cap.hidden) && 
  		self.due_date.eql?(cap.due_date)

  end

end
