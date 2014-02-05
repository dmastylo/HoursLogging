# == Schema Information
#
# Table name: time_spents
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  total_time  :float
#  notes       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  finished_at :datetime
#

class TimeSpentValidator < ActiveModel::Validator

  def validate(record)
    unless record.finished_at.nil?
      record.errors[:total_time] << "Total time must be set" if record.total_time.nil?
      record.errors[:notes] << "Notes must be set" if record.notes.empty?
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

  # Validations
  # ========================================================
  validates :user_id, presence: true
  validates_with TimeSpentValidator

  def self.currently_working
    TimeSpent.where("finished_at IS NULL")
  end

private

  def calculate_total_time
    if self.finished_at?
      self.total_time = ((finished_at - created_at) / 1.hour * 4.0).round / 4.0
    end
  end

end

