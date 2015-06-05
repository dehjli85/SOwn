class CreateClassroomActivities < ActiveRecord::Migration
  def change
    create_table :classroom_activities do |t|
    	t.belongs_to :activity
      t.belongs_to :classroom  
      t.timestamps
    end
  end
end
