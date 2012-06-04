class PlayerAllstar < ActiveRecord::Base
  belongs_to :person
  belongs_to :conference
  belongs_to :league

  attr_accessible :person, :conference, :league, :turnovers, :gp, :minutes,
                  :year, :pts, :oreb, :dreb, :asts, :steals, :blocks, :pf,
                  :fga, :fgm, :ftm, :fta, :tpa, :tpm,
                  :person_id, :conference_id, :league_id

  # it should be that way but I did not find how to drop that from ActiveAdmin
  #attr_readonly :d_reb
  attr_accessible :d_reb

  alias_attribute :reb, :d_reb
end
