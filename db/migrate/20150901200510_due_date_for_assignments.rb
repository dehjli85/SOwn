class DueDateForAssignments < ActiveRecord::Migration
  def change
  	add_column :classroom_activity_pairings, :due_date, :date
  end
end
