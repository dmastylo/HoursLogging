class TimeSpent < ActiveRecord::Base
  attr_accessible :notes, :projectid, :starttime, :stoptime, :totaltime, :userid
end
