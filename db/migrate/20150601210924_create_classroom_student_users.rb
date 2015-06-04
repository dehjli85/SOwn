class CreateClassroomStudentUsers < ActiveRecord::Migration
  def change
    create_table :classrooms_student_users do |t|
      t.belongs_to :student_user
      t.belongs_to :classroom    
      t.timestamps
    end
  end
end
