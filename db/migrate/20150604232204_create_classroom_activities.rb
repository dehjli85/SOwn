class CreateClassroomActivities < ActiveRecord::Migration
  def change
    create_table :activities_classrooms do |t|    	
      t.belongs_to :classroom  
      t.belongs_to :activity
      t.timestamps
    end
  end
end
