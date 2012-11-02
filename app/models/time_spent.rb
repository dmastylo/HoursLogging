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
  attr_accessible :notes, :totaltime, :created_at, :updated_at
  belongs_to :user
  
  validates :user_id, presence: true

  default_scope order: 'time_spents.created_at DESC'
end
