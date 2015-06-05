class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.string :name
    	t.string :description, limit: 1000 
    	t.string :instructions, limit: 1000
    	t.integer :teacher_user_id
    	t.string :activity_type    	
      t.timestamps
    end
  end
end
