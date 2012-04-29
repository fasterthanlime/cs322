class Stat < ActiveRecord::Base
  attr_accessible :pts, :oreb, :dreb, :reb, :asts, :steals, :blocks,
                  :turnovers, :tpf, :fga, :fgm, :ftm, :tpa, :tpm

  def to_s
    return "<Stat(#{id})>"
  end
end
