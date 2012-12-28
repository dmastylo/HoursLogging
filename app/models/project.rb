# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true
  has_many :time_spents

  def self.sorted_by_recent_work
    # Project.all
    # task_assignment.sort_by { |ta| ta.try(:project).try(:name) || '' }
    # Project.all.sort_by { |project| project.last_time_spent.created_at || '' }
    # Project.all.sort { |x, y| y.last_time_spent.created_at <=> x.last_time_spent.created_at }
    Project.all.sort do |y, x|
        (x.last_time_spent and y.last_time_spent) ? x.last_time_spent <=> y.last_time_spent : (x.last_time_spent ? -1 : 1) 
    end
  end

  def total_time
    self.time_spents.sum(:total_time)
  end

  def last_time_spent
    last = self.time_spents.where(finished_at: nil).first
    last ||= self.time_spents.order('finished_at DESC').first
    last
  end
end
