class AddNotesToActivityGoals < ActiveRecord::Migration
  def change
  	add_column :activity_goals, :notes, :string
  end
end
