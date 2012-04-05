class TeamController < ApplicationController
  def index
    @teams = Team.find(:all)
  end

  def view
    @team = Team.find(params[:id].to_i)
  end
end
