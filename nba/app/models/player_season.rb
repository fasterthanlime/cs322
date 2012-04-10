class PlayerSeason < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  attr_accessible :year, :player, :team

  def to_s
    return "<PlayerSeason (#{id.to_i}, #{player.person.ilkid} #{team.trigram} #{year.to_i})>"
  end
end
