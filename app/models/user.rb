# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise  :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable

    # Setup accessible (or protected) attributes for your model
    attr_accessible :email, :password, :password_confirmation, :remember_me
    # attr_accessible :title, :body

    has_many :time_spents

    def self.project_users(project_id)
        User.joins(:time_spents).where('time_spents.project_id' => project_id)
    end

    def total_time
      self.time_spents.sum(:total_time)
    end

    def last_time_spent
      last = self.time_spents.where(finished_at: nil).first
      last ||= self.time_spents.order('finished_at DESC').first
      last
    end

    def has_running_task?
        if !self.time_spents.last.nil?
            self.time_spents.last.finished_at.nil?
        else
            false
        end
    end
end