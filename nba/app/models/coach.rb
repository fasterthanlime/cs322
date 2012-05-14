class Coach < ActiveRecord::Base
  belongs_to :person
  attr_readonly :person, :person_id, :season_count, :season_win, :season_loss, :playoff_win, :playoff_loss

  def name
    "#{person.name} (Coach)"
  end

  def to_s
    "<Coach (#{id.to_i}, #{person.ilkid})>"
  end
end
