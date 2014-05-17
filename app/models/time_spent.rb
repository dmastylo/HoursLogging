# == Schema Information
#
# Table name: time_spents
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  project_id        :integer
#  total_time        :float
#  notes             :text(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  finished_at       :datetime
#  paid_status       :boolean
#  amount_paid_cents :integer
#

class TimeSpentValidator < ActiveModel::Validator

  def validate(time_spent)
    # Only check these if the note is being edited (it's already been logged)
    if time_spent.finished_at
      time_spent.errors[:total_time] << "must be set" if time_spent.total_time.nil?
      time_spent.errors[:notes] << "must be set" if time_spent.notes.empty?
    end

    # Check if the user can work on that project
    unless time_spent.user.member_projects.include? Project.find(time_spent.project_id)
      time_spent.errors[:project] << ": You can't work for a project you're not a part of"
    end
  end

end

class TimeSpent < ActiveRecord::Base

  include ActiveModel::Validations

  # Callbacks
  # ========================================================
  before_validation :calculate_total_time

  # Relationships
  # ========================================================
  belongs_to :user
  belongs_to :project

  # Money
  # ========================================================
  monetize :amount_paid_cents, numericality: { greater_than: 0 }, allow_nil: true

  # Validations
  # ========================================================
  validates :user_id, presence: true
  validates_with TimeSpentValidator

  def self.currently_working
    TimeSpent.where("finished_at IS NULL")
  end

  def set_amount_paid
    if project.billable?
      self.amount_paid = project.hourly_rate
      self.paid_status = false
    end
  end

private

  def calculate_total_time
    if finished_at?
      self.total_time = ((finished_at - created_at) / 1.hour * 4.0).round / 4.0
    end
  end

end

