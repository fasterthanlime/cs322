class TeamController < ApplicationController
  def index
    @nba = League.find_by_name('NBA')
    @aba = League.find_by_name('ABA')
    @teams = {
      "NBA" => Team.find(:all, :conditions => {:league_id => @nba.id}, :order => 'trigram'),
      "ABA" => Team.find(:all, :conditions => {:league_id => @aba.id}, :order => 'trigram')
    }
  end

  def view
    @team = Team.find(params[:id].to_i)
  end
end
