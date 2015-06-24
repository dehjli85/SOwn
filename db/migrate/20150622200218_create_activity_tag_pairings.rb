class CreateActivityTagPairings < ActiveRecord::Migration
  def change
    create_table :activity_tag_pairings do |t|
    	t.integer :activity_tag_id
    	t.integer :activity_id
      t.timestamps
    end
  end
end
