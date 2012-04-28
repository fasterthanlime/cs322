class TeamSeason < ActiveRecord::Base
  belongs_to :team
  has_one :offensive_team_stat, :class_name => "TeamStat",
                                :conditions => {
                                  :team_stat_tactique_id => TeamStatTactique::OFFENSIVE
                                }
  has_one :defensive_team_stat, :as => "TeamStat",
                                :conditions => {
                                  :team_stat_tactique_id => TeamStatTactique::DEFENSIVE
                                }

  attr_accessible :year, :team, :league, :won, :pace, :lost

  def to_s
    return "<TeamSeason (#{id.to_i}, #{team.trigram} #{year.to_i})>"
  end
end
