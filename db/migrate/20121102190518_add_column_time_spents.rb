class AddColumnTimeSpents < ActiveRecord::Migration
    def change
        add_column :time_spents, :finished_at, :datetime
    end
end
