class WelcomeController < ApplicationController
  def index
    @teams_count = Team.count()
    @people_count = Person.count()
  end
end
