class AddActivityLink < ActiveRecord::Migration
  def change
  	add_column :activities, :link, :string
  end
end
