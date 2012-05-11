class Person < ActiveRecord::Base
  has_one :coach
  has_one :player
  has_many :drafts
  has_many :coach_seasons
  attr_accessible :ilkid, :firstname, :lastname

  def fullname
    return "#{firstname} #{lastname}"
  end

  def name
    return fullname
  end

  def to_s
    return "<Person (#{id.to_i}, #{ilkid}, #{firstname} #{lastname})>"
  end
end
