class Coach < ActiveRecord::Base
  belongs_to :person
  has_many :coach_seasons
  attr_accessible :person

  def season_win
    CoachSeason.sum(:season_win, :conditions => { :coach_id => id })
  end
  
  def season_loss
    CoachSeason.sum(:season_loss, :conditions => { :coach_id => id })
  end

  def playoff_win
    CoachSeason.sum(:playoff_win, :conditions => { :coach_id => id })
  end

  def playoff_loss
    CoachSeason.sum(:playoff_loss, :conditions => { :coach_id => id })
  end

  def name
    "#{person.name} (Coach)"
  end

  def to_s
    "<Coach (#{id.to_i}, #{person.ilkid})>"
  end
end
