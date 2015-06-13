class CreateStudentPerformances < ActiveRecord::Migration
  def change
    create_table :student_performances do |t|
    	t.integer :student_user_id
    	t.integer :activities_classrooms_id
    	t.float :scored_performance
    	t.boolean :completed_performance
    	t.datetime :performance_date
      t.timestamps
    end
  end
end
