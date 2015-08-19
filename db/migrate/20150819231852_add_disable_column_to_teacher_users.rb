class AddDisableColumnToTeacherUsers < ActiveRecord::Migration
  def change

  	add_column :teacher_users, :disabled, :boolean, null: false, default: false

  	TeacherUser.all.each do |teacher|
  		teacher.disabled = false
  		if(!teacher.save)
  			teacher.errors.each do |k,v|
  				puts "#{k}: #{v}"
  			end
  		end
  	end

  end
end
