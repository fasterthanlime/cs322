class PlayerSeason < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  attr_accessible :year, :player, :team

  def name
    return "#{player.person.ilkid} #{team.trigram} #{year}"
  end

  def to_s
    return "<PlayerSeason (#{id}, #{player.person.ilkid} #{team.trigram} #{year})>"
  end
end
