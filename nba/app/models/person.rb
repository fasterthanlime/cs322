class Person < ActiveRecord::Base
  has_one :coach
  has_one :player
  has_many :drafts, :order => 'year DESC, round DESC'
  has_many :player_seasons, :order => 'year'
  has_many :player_allstars, :order => 'year'
  has_many :coach_seasons, :order => 'year'
  attr_accessible :ilkid, :firstname, :lastname, :position, :height, :weight,
                  :birthdate

  def fullname
    return "#{firstname} #{lastname}"
  end

  def name
    return fullname
  end

  def height_in_ft
    feet = height / 12
    inches = height % 12
    return "#{feet}' #{inches}\""
  end

  def to_s
    return "<Person (#{id.to_i}, #{ilkid}, #{firstname} #{lastname})>"
  end
end
