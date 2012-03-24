class Coach < ActiveRecord::Base
  belongs_to :person
  attr_accessible :season_win, :season_loss, :playoff_win, :playoff_loss
end
