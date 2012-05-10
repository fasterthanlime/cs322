class PlayerStat < ActiveRecord::Base
  belongs_to :player_season
  belongs_to :player_season_type

  attr_accessible :player_season, :player_season_type, :turnovers, :gp, :minutes,
                  :pts, :oreb, :dreb, :reb, :asts, :steals, :blocks,
                  :pf, :fga, :fgm, :ftm, :fta, :tpa, :tpm
end
