class Team < ActiveRecord::Base
  has_many :seasons, :class_name => "TeamSeason"
  attr_accessible :name, :trigram, :location

  def to_s
    return "<Team (#{id.to_i}, #{trigram} #{name})>"
  end
end
