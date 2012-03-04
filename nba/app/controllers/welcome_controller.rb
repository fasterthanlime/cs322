class WelcomeController < ApplicationController
  def index
    @people = Person.find(:all)
  end
end
