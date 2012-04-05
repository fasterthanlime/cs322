class PersonController < ApplicationController
  def index
    @people = Person.find(:all)
  end
end
