class CreateActivityLevels < ActiveRecord::Migration
  def change
    create_table :activity_levels do |t|
    	t.integer :activity_id
    	t.string :name
      t.timestamps
    end
  end
end
