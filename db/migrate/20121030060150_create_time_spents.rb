class CreateTimeSpents < ActiveRecord::Migration
  def change
    create_table :time_spents do |t|
      t.integer :userid
      t.integer :projectid
      t.datetime :starttime
      t.datetime :stoptime
      t.float :totaltime
      t.string :notes

      t.timestamps
    end
  end
end
