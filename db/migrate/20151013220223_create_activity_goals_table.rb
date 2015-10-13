class CreateActivityGoalsTable < ActiveRecord::Migration
  def change
    create_table :activity_goals_tables do |t|
    	t.integer :classroom_activity_pairing_id
    	t.integer :student_user_id
    	t.float :score_goal
    	t.datetime :goal_date
    	t.timestamps
    end
  end
end
