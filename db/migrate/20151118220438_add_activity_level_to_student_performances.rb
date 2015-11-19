class AddActivityLevelToStudentPerformances < ActiveRecord::Migration
  def change
  	add_column :student_performances, :activity_level_id, :integer
  end
end
