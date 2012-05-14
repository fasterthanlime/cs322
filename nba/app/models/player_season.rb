class PlayerSeason < ActiveRecord::Base
  belongs_to :person
  belongs_to :team
  has_one :regular_season, :class_name => 'PlayerStat', :conditions => {:player_season_type_id => PlayerSeasonType::REGULAR}
  has_one :playoff_season, :class_name => 'PlayerStat', :conditions => {:player_season_type_id => PlayerSeasonType::PLAYOFF}
  attr_accessible :year, :person, :team

  def name
    return "#{person.ilkid} #{team.trigram} #{year}"
  end

  def to_s
    return "<PlayerSeason (#{id}, #{name})>"
  end
end
