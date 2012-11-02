# == Schema Information
#
# Table name: time_spents
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  starttime  :datetime
#  stoptime   :datetime
#  totaltime  :float
#  notes      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TimeSpent < ActiveRecord::Base
  attr_accessible :notes, :starttime, :stoptime, :totaltime
  belongs_to :user
  
  validates :user_id, presence: true
end
