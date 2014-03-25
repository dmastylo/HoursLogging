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

  # Relationships
  # ========================================================
  belongs_to :creator, class_name: "User"
  has_many :time_spents, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :members, class_name: "User", through: :project_users, source: :user

  # Project methods
  # ========================================================
  def self.sorted_by_recent_work
    # Project.all
    # task_assignment.sort_by { |ta| ta.try(:project).try(:name) || '' }
    # Project.all.sort_by { |project| project.last_time_spent.created_at || '' }
    # Project.all.sort { |x, y| y.last_time_spent.created_at <=> x.last_time_spent.created_at }
    Project.all.sort do |y, x|
      if x.last_time_spent && y.last_time_spent
        x.last_time_spent <=> y.last_time_spent
      else
        x.last_time_spent ? 1 : -1
      end
    end
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
