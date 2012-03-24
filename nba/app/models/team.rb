class Team < ActiveRecord::Base
  belongs_to :conference
  attr_accessible :name, :trigram, :location, :conference

  def to_s
    return "<Team (#{id.to_i}, #{name},#{trigram})>"
  end
end
