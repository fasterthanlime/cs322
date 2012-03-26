class TeamStat < ActiveRecord::Base
  belongs_to :stat
  belongs_to :team_season
  belongs_to :team_stat_tactique

  attr_accessible :stat, :team_season, :team_stat_tactique
end
