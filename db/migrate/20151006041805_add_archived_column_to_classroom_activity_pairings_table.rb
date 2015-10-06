class AddArchivedColumnToClassroomActivityPairingsTable < ActiveRecord::Migration
  def change

  	add_column :classroom_activity_pairings, :archived, :boolean
  end
end
