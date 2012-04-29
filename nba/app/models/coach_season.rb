class CoachSeason < ActiveRecord::Base
  belongs_to :coach
  belongs_to :team
  attr_accessible :coach, :team, :year, :year_order, :season_win, :season_loss, :playoff_win, :playoff_loss

  def to_s
    return "<CoachSeason (#{team.trigram}, #{coach.person.ilkid}, #{year.to_i})>"
  end
end
