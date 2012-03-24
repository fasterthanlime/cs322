class Person < ActiveRecord::Base
  has_one :coach
  has_one :player
  attr_accessible :ilkid, :firstname, :lastname
end
