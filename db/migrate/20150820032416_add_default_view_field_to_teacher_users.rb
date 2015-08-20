class AddDefaultViewFieldToTeacherUsers < ActiveRecord::Migration
  def change
  	add_column :teacher_users, :default_view_student, :boolean, null: false, default: false

  	TeacherUser.all.each do |teacher|
  		teacher.default_view_student = false
  		if !teacher.save
  			teacher.errors.each do |k,v|
  				puts "#{k}: #{v}"  				
  			end
  		end
  	end
  end
end
