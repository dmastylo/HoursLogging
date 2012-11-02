class Project < ActiveRecord::Base
  attr_accessible :name
  validates presence: true
end
