class PlayerAllstar < ActiveRecord::Base
  belongs_to :person
  belongs_to :conference
  belongs_to :league

  attr_accessible :person, :conference, :league, :turnovers, :gp, :minutes,
                  :year, :pts, :oreb, :dreb, :reb, :asts, :steals, :blocks,
                  :pf, :fga, :fgm, :ftm, :fta, :tpa, :tpm

  def to_s
    return "<PlayerAllstar (#{id.to_i}, #{person.ilkid} #{conference.name} #{year.to_i})>"
  end
end
