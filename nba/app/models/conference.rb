class Conference < ActiveRecord::Base
  has_many :teams
  attr_accessible :name

  def to_s
    "<Conference(#{name}>"
  end
end
