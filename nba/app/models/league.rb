class League < ActiveRecord::Base
  has_many :teams
  attr_accessible :name
end
