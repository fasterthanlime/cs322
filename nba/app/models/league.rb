class League < ActiveRecord::Base
  has_many :team_season
  attr_accessible :name
end
