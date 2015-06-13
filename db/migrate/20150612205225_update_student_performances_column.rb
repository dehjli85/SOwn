class UpdateStudentPerformancesColumn < ActiveRecord::Migration
  def change
  	rename_column :student_performances, :activities_classrooms_id, :classroom_activity_pairing_id
  end
end
