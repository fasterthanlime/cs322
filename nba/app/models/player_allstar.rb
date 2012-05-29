class PlayerAllstar < ActiveRecord::Base
  belongs_to :person
  belongs_to :conference
  belongs_to :league

  attr_accessible :person, :conference, :league, :turnovers, :gp, :minutes,
                  :year, :pts, :oreb, :dreb, :asts, :steals, :blocks, :pf,
                  :fga, :fgm, :ftm, :fta, :tpa, :tpm

  attr_readonly :d_reb
  alias_attribute :reb, :d_reb
end
