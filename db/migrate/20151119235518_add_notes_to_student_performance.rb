class AddNotesToStudentPerformance < ActiveRecord::Migration
  def change
  	add_column :student_performances, :notes, :string
  end
end
