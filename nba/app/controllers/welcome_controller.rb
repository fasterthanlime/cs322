class WelcomeController < ApplicationController
  def index
    @teams = Team.find(:all, :order => :trigram)
  end
end
