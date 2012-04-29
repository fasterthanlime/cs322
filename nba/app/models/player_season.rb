class PlayerSeason < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  has_one :regular_season, :class_name => 'PlayerStat', :conditions => {:player_season_type_id => PlayerSeasonType::REGULAR}
  has_one :playoff_season, :class_name => 'PlayerStat', :conditions => {:player_season_type_id => PlayerSeasonType::PLAYOFF}
  attr_accessible :year, :player, :team

  def name
    return "#{player.person.ilkid} #{team.trigram} #{year}"
  end

  def to_s
    return "<PlayerSeason (#{id}, #{player.person.ilkid} #{team.trigram} #{year})>"
  end
end
