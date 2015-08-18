class AddSortOrderColumnToClassroomActivityPairings < ActiveRecord::Migration
  def change

  	add_column :classroom_activity_pairings, :sort_order, :integer

  	classroom_ids = ClassroomActivityPairing.all.select("classroom_id").distinct.pluck(:classroom_id)

  	classroom_ids.each do |id|

  		caps = ClassroomActivityPairing.where({classroom_id: id}).order("created_at ASC")

  		caps.each_with_index do |cap, index|

  			cap.sort_order = index
  			if(!cap.save)
  				cap.errors.each do |k,v|
  				end
  			end

  		end

  	end


  	

  end
end
