class CreateClassroomActivityPairings < ActiveRecord::Migration
  def change
    create_table :classroom_activity_pairings do |t|
    	t.belongs_to :classroom  
      t.belongs_to :activity
      t.timestamps
    end
  end
end
