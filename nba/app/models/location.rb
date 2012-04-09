class Location < ActiveRecord::Base
  has_many :drafts
  attr_accessible :name

  def to_s
    return "<Location (#{id.to_i}, #{name})>"
  end
end
