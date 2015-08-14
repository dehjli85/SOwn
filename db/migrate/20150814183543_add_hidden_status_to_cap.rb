class AddHiddenStatusToCap < ActiveRecord::Migration
  def change

  	add_column :classroom_activity_pairings, :hidden, :boolean, null: false, default: false

  	ClassroomActivityPairing.all.each do |cap|
  		cap.hidden = false
  		if(!cap.save)
  			cap.errors.each do |k,v|
  				puts "#{k}: #{v}"
  			end
  		end
  	end

  end
end
