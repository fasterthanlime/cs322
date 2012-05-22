class Team < ActiveRecord::Base
  has_many :team_stats, :order => 'year, team_stat_tactique_id'
  has_many :coach_seasons, :order => 'year, year_order'
  belongs_to :league
  attr_accessible :name, :league, :trigram, :location

  def fullname
    "#{name} (#{trigram})"
  end

  def to_s
    return "<Team (#{id.to_i}, #{trigram} #{name})>"
  end
end
