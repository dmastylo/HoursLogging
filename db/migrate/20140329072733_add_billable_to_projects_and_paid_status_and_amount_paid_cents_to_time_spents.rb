class AddBillableToProjectsAndPaidStatusAndAmountPaidCentsToTimeSpents < ActiveRecord::Migration
  def change
    add_column :projects, :billable, :boolean
    add_column :time_spents, :paid_status, :boolean
    add_column :time_spents, :amount_paid_cents, :integer
  end
end
