# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string(255)
#  creator_id  :integer
#

class Project < ActiveRecord::Base

  # Callbacks
  # ========================================================
  before_create :add_creator_to_members

  # Validations
  # ========================================================
  validates :name, presence: true
  validates :description, presence: true
  validates :privacy_type, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 2, message: "is an invalid privacy type" }

  # Relationships
  # ========================================================
  belongs_to :creator, class_name: "User"
  has_many :time_spents, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :members, class_name: "User", through: :project_users, source: :user

  # Constants
  # ========================================================
  class PrivacyType
    PUBLIC = 1
    PRIVATE = 2
  end

  # Privacy types
  # ========================================================
  def public?
    privacy_type == PrivacyType::PUBLIC
  end

  def private?
    privacy_type == PrivacyType::PRIVATE
  end

  # Projects
  # ========================================================
  # TODO
  def self.visible_projects(user)
    Project.joins(:project_users).where('privacy_type = ? OR project_users.user_id = ?', PrivacyType::PUBLIC, user.id)
  end

  # Users
  # ========================================================
  def users_who_worked
    User.includes(:time_spents).where('time_spents.project_id = ?', self.id)
  end

  # Time Spents
  # ========================================================
  def total_time
    time_spents.sum(:total_time)
  end

  def last_time_spent
    last = self.time_spents.where(finished_at: nil).first
    last ||= self.time_spents.order('finished_at DESC').first
  end

private

  def add_creator_to_members
    unless members.include? creator
      members << creator
    end
  end

end
