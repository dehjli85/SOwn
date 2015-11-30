class AddLevelIdToActivityGoals < ActiveRecord::Migration
  def change
  	add_column :activity_goals, :activity_level_id, :integer
  end
end
