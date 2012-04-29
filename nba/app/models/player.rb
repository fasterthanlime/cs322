class Player < ActiveRecord::Base
  belongs_to :person
  has_many :drafts
  has_many :player_seasons
  has_many :player_allstars
  attr_accessible :person, :position, :height, :weight, :birthdate

  def name
    "#{person.name} (Player)"
  end

  def height_in_ft
    feet = height / 12
    inches = height % 12
    return "#{feet}' #{inches}\""
  end

  def to_s
    return "<Player (#{id.to_i}, #{person.ilkid})>"
  end
end
