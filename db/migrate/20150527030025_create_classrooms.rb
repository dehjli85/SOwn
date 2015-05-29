class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
    	t.integer :teacher_user_id
    	t.string :name
    	t.string :description
    	t.string :classroom_code
      t.timestamps
    end
  end
end
