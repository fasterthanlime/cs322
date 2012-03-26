class TeamController < ApplicationController
  def view
    @team = Team.find(params[:id].to_i)
  end
end
