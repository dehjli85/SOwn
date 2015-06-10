class ChangeStudentUserColumnNames < ActiveRecord::Migration
  def change
  	rename_column :student_users, :password, :salt
  	rename_column :student_users, :password_hash, :password_digest
  end
end
