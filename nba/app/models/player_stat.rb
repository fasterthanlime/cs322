class PlayerStat < ActiveRecord::Base
  belongs_to :player_season
  belongs_to :player_season_type

  attr_accessible :player_season, :player_season_type, :turnovers, :gp,
                  :minutes, :pts, :oreb, :dreb, :asts, :steals, :blocks, :pf,
                  :fga, :fgm, :fta, :ftm, :tpa, :tpm
  attr_readonly :d_reb
  alias_attribute :reb, :d_reb
end
