class FixColumnName < ActiveRecord::Migration
    def change
        rename_column :time_spents, :projectid, :project_id
    end
end
