class Draft < ActiveRecord::Base
  belongs_to :person, :foreign_key => 'id'
  belongs_to :team
  belongs_to :location
  attr_readonly :person, :team, :location, :year, :round, :selection

  def to_s
    return "<Draft (#{id.to_i}, #{person.ilkid}, #{year}.#{round})>"
  end
end
