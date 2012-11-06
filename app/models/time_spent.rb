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
    before_update :finish_time

    attr_accessible :notes, :totaltime, :created_at, :finished_at, :project_id
    belongs_to :user #, :project

    validates :user_id, presence: true
    # validates :notes, presence: true

    # default_scope order: 'time_spents.created_at DESC'
    
    private
        def finish_time
            @total_time = (Time.now - self.created_at) / 1.hour

            # Don't allow under 15 minutes of work
            if @total_time < 0.25 || !attribute_present?("notes")
                false
            # Round to the nearest 15 minutes
            else
                self.total_time = (@total_time * 4.0).round / 4.0
                true
            end
        end
end

