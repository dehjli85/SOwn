class RenameUsersTableToTeacherUsers < ActiveRecord::Migration
  def change
  	rename_table :users, :teacher_users
  end
end
