class PlayerStat < ActiveRecord::Base
  belongs_to :stat
  belongs_to :player_season
  belongs_to :player_season_type

  attr_accessible :stat, :player_season, :player_season_type, :gp, :minutes
end
