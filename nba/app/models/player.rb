class Player < ActiveRecord::Base
  belongs_to :person
  attr_accessible :person, :position, :height, :weight, :birthdate

  def name
    "#{person.name} (Player)"
  end

  def to_s
    return "<Player (#{id.to_i}, #{person.ilkid})>"
  end
end
