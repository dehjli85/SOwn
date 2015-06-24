class AddBenchmarkScoresToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :benchmark1_score, :float
  	add_column :activities, :benchmark2_score, :float
  end
end
