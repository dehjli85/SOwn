class AddLevelAbbreviationToActivityLevels < ActiveRecord::Migration
  def change
  	add_column :activity_levels, :abbreviation, :string
  end
end
