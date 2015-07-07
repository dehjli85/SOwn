class UpdateStudentPerformanceForVerification < ActiveRecord::Migration
  def change
  	add_column :student_performances, :verified, :boolean
  end
end
