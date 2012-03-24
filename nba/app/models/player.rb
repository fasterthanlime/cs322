class Player < ActiveRecord::Base
  belongs_to :person
  attr_accessible :height, :weight, :birthdate
end
