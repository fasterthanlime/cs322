class TeamStat < ActiveRecord::Base
  belongs_to :team
  belongs_to :team_stat_tactique

  attr_accessible :team, :team_stat_tactique, :year, :pace,
                  :pts, :oreb, :dreb, :reb, :asts, :steals, :blocks,
                  :pf, :fga, :fgm, :ftm, :fta, :tpa, :tpm

  def name
    return "#{team.name} #{year} #{team_stat_tactique.name}"
  end

  def to_s
    return "<TeamStat(#{id}, #{name})>"
  end
end
