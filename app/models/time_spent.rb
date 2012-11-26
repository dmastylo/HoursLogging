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
    if !record.finished_at.nil?
      if record.total_time.nil?
        record.errors[:total_time] << "Total time must be set"
      end

      if record.notes.empty?
        record.errors[:notes] << "Notes must be set"
      end
    end
  end
end

class TimeSpent < ActiveRecord::Base
  include ActiveModel::Validations

  before_validation :finish_time

  attr_accessible :notes, :total_time, :created_at, :finished_at, :project_id
  belongs_to :user
  belongs_to :project

  validates :user_id, presence: true
  validates_with TimeSpentValidator

  # validates :notes, presence: true

  # default_scope order: 'time_spents.created_at DESC'
  
private
  def finish_time
    if !self.finished_at.nil?
      self.total_time = ((self.finished_at - self.created_at) / 1.hour * 4.0).round / 4.0
    end
  end
end

