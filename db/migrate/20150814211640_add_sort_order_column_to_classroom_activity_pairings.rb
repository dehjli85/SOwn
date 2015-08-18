class AddSortOrderColumnToClassroomActivityPairings < ActiveRecord::Migration
  def change

  	add_column :classroom_activity_pairings, :sort_order, :integer

  	

  end
end
