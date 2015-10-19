class AddGenderToTeacherUsersTable < ActiveRecord::Migration
  def change
  	add_column :teacher_users, :gender, :string
  	add_column :teacher_users, :salutation, :string
  end
end
