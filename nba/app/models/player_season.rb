class PlayerSeason < ActiveRecord::Base
  belongs_to :person
  belongs_to :team
  belongs_to :player_season_type

  attr_accessible :year, :person, :team, :player_season_type, :turnovers, :gp,
                  :minutes, :pts, :oreb, :dreb, :asts, :steals, :blocks, :pf,
                  :fga, :fgm, :fta, :ftm, :tpa, :tpm,
                  :person_id, :team_id, :player_season_type_id
  # FIXME: should be readonly (see ActiveAdmin)
  attr_accessible :d_reb
  alias_attribute :reb, :d_reb

  def name
    return "#{person.ilkid} #{team.trigram} #{year}"
  end

  def to_s
    return "<PlayerSeason (#{id}, #{name})>"
  end
end
