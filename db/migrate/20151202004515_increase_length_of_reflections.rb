class IncreaseLengthOfReflections < ActiveRecord::Migration
  def up
  	change_column :activity_goal_reflections, :reflection, :string, :limit => 1000
  	change_column :activity_goals, :notes, :string, :limit => 1000
  end

  def down
  	change_column :activity_goal_reflections, :reflection, :string, :limit => 255
  	change_column :activity_goals, :notes, :string, :limit => 255
  end

end
