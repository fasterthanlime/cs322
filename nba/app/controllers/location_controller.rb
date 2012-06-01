class LocationController < ApplicationController
  def index
    @locations = Location.all(:order => 'name')
  end

  def view
    @location = Location.find(params[:id].to_i)
  end
end
