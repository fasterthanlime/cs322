class TeamStat < ActiveRecord::Base
  belongs_to :stat
  belongs_to :team
  belongs_to :team_stat_tactique

  attr_accessible :stat, :team, :team_stat_tactique, :year, :pace

  def name
    return "#{team.name} #{year} #{team_stat_tactique.name}"
  end

  def to_s
    return "<TeamStat(#{id}, #{name})>"
  end
end
