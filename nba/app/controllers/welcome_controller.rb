class WelcomeController < ApplicationController
  def index
    @people = Person.find(:all)
    @leagues = League.find(:all)
    @conferences = Conference.find(:all)
  end
end
