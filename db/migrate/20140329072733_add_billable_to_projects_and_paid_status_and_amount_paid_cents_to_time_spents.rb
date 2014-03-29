class AddBillableToProjectsAndPaidStatusAndAmountPaidCentsToTimeSpents < ActiveRecord::Migration
  def change
    add_column :projects, :billable, :boolean
    add_column :projects, :hourly_rate_cents, :integer
    add_column :time_spents, :paid_status, :boolean
    add_column :time_spents, :amount_paid_cents, :integer

    Project.reset_column_information
    Project.all.each do |project|
      project.update_attribute(:billable, false) if project.billable.blank?
    end
  end
end
