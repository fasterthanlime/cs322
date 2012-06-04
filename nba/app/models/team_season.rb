class TeamSeason < ActiveRecord::Base
  belongs_to :team

  attr_accessible :team, :team_id, :year, :pace,
                  :opts, :ooreb, :odreb, :oreb, :oasts, :osteals, :oblocks,
                  :opf, :ofga, :ofgm, :oftm, :ofta, :otpa, :otpm,
                  :dpts, :doreb, :ddreb, :dreb, :dasts, :dsteals, :dblocks,
                  :dpf, :dfga, :dfgm, :dftm, :dfta, :dtpa, :dtpm

  # FIXME: should be readonly
  attr_accessible :d_coach_counter, :d_season_win, :d_season_loss

  def name
    return "#{team.name} #{year}"
  end

  def to_s
    return "<TeamSeason(#{id}, #{name})>"
  end
end
