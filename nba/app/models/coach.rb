class Coach < ActiveRecord::Base
  belongs_to :person
  attr_accessible :person, :season_win, :season_loss, :playoff_win, :playoff_loss

  def to_s
    return "<Coach (#{id.to_i}, #{person.ilkid})>"
  end
end
