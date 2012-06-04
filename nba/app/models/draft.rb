class Draft < ActiveRecord::Base
  belongs_to :person
  belongs_to :team
  belongs_to :location
  attr_accessible :person, :person_id, :team, :team_id, :location, :location_id,
                  :year, :round, :selection

  def to_s
    return "<Draft (#{id.to_i}, #{person.ilkid}, #{year}.#{round})>"
  end
end
