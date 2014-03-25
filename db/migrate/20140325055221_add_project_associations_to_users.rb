class AddProjectAssociationsToUsers < ActiveRecord::Migration
  def change
    add_column :projects, :creator_id, :integer

    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end

    Project.reset_column_information
    Project.all.each do |project|
      # Set creator to random person at first, needs to be manually changed
      if project.creator.blank? && project.members.blank?
        project.update_attribute(:creator_id, User.first.id)
        project.users_who_worked.each { |user| project.members << user }
        project.save
      end
    end
  end
end
