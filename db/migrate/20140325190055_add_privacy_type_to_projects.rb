class AddPrivacyTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :privacy_type, :integer

    Project.reset_column_information
    Project.all.each do |project|
      project.update_attribute(:privacy_type, Project::PrivacyType::PUBLIC) if project.privacy_type.blank?
    end
  end
end
