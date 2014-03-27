# == Schema Information
#
# Table name: time_spents
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  total_time  :float
#  notes       :text(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  finished_at :datetime
#

require 'spec_helper'

describe TimeSpent do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  before { @time_spent = user.time_spents.new(project_id: project.id) }
  subject { @time_spent }
  
  describe "validations" do
    describe "before completion" do
      it { should be_valid } # Initially valid

      describe "with notes" do
        before { @time_spent.notes = "Lorem ipsum" }
        it { should be_valid }
      end
    end

    describe "after satisfactory completion" do
      before { @time_spent.finished_at = Time.now + 3600 }

      describe "without notes" do
        it { should_not be_valid }
      end

      describe "with notes" do
        before { @time_spent.notes = "Lorem ipsum" }
        it { should be_valid }
      end

    end
  end

end
