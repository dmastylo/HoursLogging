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

class TimeSpent < ActiveRecord::Base
	before_validation :finish_time

	attr_accessible :notes, :total_time, :created_at, :finished_at, :project_id
	belongs_to :user
	belongs_to :project

	validates :user_id, presence: true
	# validates :notes, presence: true

	# default_scope order: 'time_spents.created_at DESC'
	
private
	def finish_time
    if !self.finished_at.nil?
      self.total_time = ((self.finished_at - self.created_at) / 1.hour * 4.0).round / 4.0
    end
  end
  
end