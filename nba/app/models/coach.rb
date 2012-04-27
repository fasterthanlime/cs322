class Coach < ActiveRecord::Base
  belongs_to :person
  has_many :coaches_teams
  attr_accessible :person, :season_win, :season_loss, :playoff_win, :playoff_loss
  accepts_nested_attributes_for :coaches_teams

  def name
    return "#{person.name} (Coach)"
  end

  def to_s
    return "<Coach (#{id.to_i}, #{person.ilkid})>"
  end
end
