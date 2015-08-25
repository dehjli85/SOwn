class FixSortOrdersForClassroomActivityPairings < ActiveRecord::Migration
  def change

  	classrooms = Classroom.all
  	classrooms.each do |classroom|
  		caps = classroom.classroom_activity_pairings.order("classroom_id, sort_order ASC")
  		caps.each_with_index do |cap, index|
  			puts "old: #{cap.sort_order}, new: #{index}"
  			cap.sort_order = index
  			cap.save
  		end
  	end


  end
end
