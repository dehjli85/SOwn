class ChangeClassroomsStudentUsersToClassroomStudentUser < ActiveRecord::Migration
  def change
  	rename_table :classrooms_student_users, :classroom_student_users
  end
end
