class PlayerAllstar < ActiveRecord::Base
  belongs_to :stat
  belongs_to :player
  belongs_to :conference

  attr_accessible :stat, :player, :conference, :turnovers, :gp, :minutes, :year

  def to_s
    return "<PlayerAllstar (#{id.to_i}, #{player.person.ilkid} #{conference.name} #{year.to_i})>"
  end
end
