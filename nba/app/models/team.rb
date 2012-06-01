class Team < ActiveRecord::Base
  has_many :team_seasons, :order => 'year'
  has_many :coach_seasons, :order => 'year, year_order'
  belongs_to :league
  attr_accessible :name, :league, :trigram, :location

  def fullname
    "#{name} (#{trigram})"
  end

  def to_s
    return "<Team (#{id}, #{trigram} #{name})>"
  end
end
