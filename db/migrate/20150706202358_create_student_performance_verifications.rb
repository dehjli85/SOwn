class CreateStudentPerformanceVerifications < ActiveRecord::Migration
  def change
    create_table :student_performance_verifications do |t|
      t.integer :classroom_activity_pairing_id
      t.integer :student_user_id
      t.timestamps
    end
  end
end
