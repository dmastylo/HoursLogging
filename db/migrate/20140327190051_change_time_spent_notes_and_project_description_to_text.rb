class ChangeTimeSpentNotesAndProjectDescriptionToText < ActiveRecord::Migration
  def change
    change_column :time_spents, :notes, :text
    change_column :projects, :description, :text
  end
end
