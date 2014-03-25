# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProjectUser < ActiveRecord::Base

  # Relationships
  # ========================================================
  belongs_to :user
  belongs_to :project

end
