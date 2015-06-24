class AddMinAndMaxRangesForScores < ActiveRecord::Migration
  def change
  	add_column :activities, :min_score, :float
  	add_column :activities, :max_score, :float
  end
end
