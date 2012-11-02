class DeleteTimeSpentColumns < ActiveRecord::Migration
    def change
        remove_column :time_spents, :starttime
        remove_column :time_spents, :stoptime
    end
end
