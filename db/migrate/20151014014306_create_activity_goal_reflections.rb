class CreateActivityGoalReflections < ActiveRecord::Migration
  def change
    create_table :activity_goal_reflections do |t|
    	t.integer :activity_goal_id
    	t.integer :student_user_id
    	t.integer :teacher_user_id
    	t.string :reflection
    	t.datetime :reflection_date
      t.timestamps
    end
  end
end
