class Team < ActiveRecord::Base
  has_many :seasons, :class_name => "TeamSeason"
  belongs_to :league
  attr_accessible :name, :league, :trigram, :location

  def to_s
    return "<Team (#{id.to_i}, #{trigram} #{name})>"
  end
end
