class ChangeTotalTimeColumn < ActiveRecord::Migration
    def change
        rename_column :time_spents, :totaltime, :total_time
    end
end
