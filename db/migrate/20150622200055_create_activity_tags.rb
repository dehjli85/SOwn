class CreateActivityTags < ActiveRecord::Migration
  def change
    create_table :activity_tags do |t|
    	t.string :name
      t.timestamps
    end
  end
end
