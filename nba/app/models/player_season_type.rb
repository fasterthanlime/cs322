class PlayerSeasonType < ActiveRecord::Base
  REGULAR = 1
  PLAYOFF = 2

  has_many :player_seasons
  has_many :players
end
