class ChangeTeacherUserColumnNames < ActiveRecord::Migration
  def change
  	rename_column :teacher_users, :password, :salt
  	rename_column :teacher_users, :password_hash, :password_digest
  end
end
