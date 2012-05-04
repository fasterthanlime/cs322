class Stat < ActiveRecord::Base
  attr_accessible :pts, :oreb, :dreb, :reb, :asts, :steals, :blocks,
                  :pf, :fga, :fgm, :ftm, :fta, :tpa, :tpm

  def to_s
    return "<Stat(#{id})>"
  end
end
