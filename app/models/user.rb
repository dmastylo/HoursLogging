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

  # Relationships
  # ========================================================
  has_many :time_spents

  # Projects
  # ========================================================
  def total_time_of_project(project)
    project.time_spents.where(user_id: self.id).sum(:total_time)
    #time_spents.where('project_id = ? ', project_id).sum(:total_time)
  end

  # Time Spents
  # ========================================================
  def working_time_spent(existing_task)
    existing_task ? time_spents.last : time_spents.build
  end

  def total_time
    time_spents.sum(:total_time)
  end

  def last_time_spent
    last = self.time_spents.where(finished_at: nil).first
    last ||= self.time_spents.order('finished_at DESC').first
  end

  def has_running_task?
    if !time_spents.last.nil?
      time_spents.last.finished_at.nil?
    else
      false
    end
  end

end