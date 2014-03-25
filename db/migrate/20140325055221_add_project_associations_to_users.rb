class AddProjectAssociationsToUsers < ActiveRecord::Migration
  def change
    add_column :projects, :creator_id, :integer

    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
