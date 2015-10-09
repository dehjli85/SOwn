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

  # sort_order_hash: key is the index, value is the Classroom Activity Pairing id
  def self.sort_activities(sorted_cap_ids)
    
    # Check that all of the pairings are from the same classroom and includes all of them
    classroom_id = ClassroomActivityPairing.find(sorted_cap_ids[0]).classroom_id
    cap_ids = ClassroomActivityPairing.where(classroom_id: classroom_id).where(archived: false).pluck(:id).sort
    if !sorted_cap_ids.sort.eql?(cap_ids)
      puts "Incomplete ClassroomActivityPairing Set Error"
      raise "Incomplete ClassroomActivityPairing Set Error"
    end

    sorted_cap_ids.each_with_index do |cap_id, index|
      cap = ClassroomActivityPairing.where({id: cap_id}).first
      
      if cap
        cap.sort_order = index
        if !cap.save
          errors.push(cap.errors)
        end
      else
        puts "Invalid ClassroomActivityPairing Error"
        raise "Invalid ClassroomActivityPairing Error"

      end

    end
  end

end
