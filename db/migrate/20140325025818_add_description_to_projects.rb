class AddDescriptionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :description, :string

    Project.reset_column_information
    Project.all.each do |project|
      project.update_attribute(:description, "placeholder") if project.description.blank?
    end
  end
end
