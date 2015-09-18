class LocalStudentUserId < ActiveRecord::Migration
  def change
  	add_column :student_users, :local_id, :string
  end
end
