class AddGenderToStudentUsersTable < ActiveRecord::Migration
  def change
  	add_column :student_users, :gender, :string
  	add_column :student_users, :salutation, :string
  end
end
