=begin

This guy GARMADI01 got drafts two times in a row for the same team.
There are two JOHNSGE02 from the same year, team, same everything but location.
=end
class Draft < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  belongs_to :location
  attr_accessible :player, :team, :location, :year, :round, :selection

  def to_s
    return "<Draft (#{id.to_i}, #{player.person.ilkid}, #{year})>"
  end
end
