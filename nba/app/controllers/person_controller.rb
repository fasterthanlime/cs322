class PersonController < ApplicationController
  def index
    @people = Person.find(
      :all,
      :conditions => 'ilkid IS NOT NULL',
      :order => 'lastname, firstname'
    )
  end

  def view
    @person = Person.find(params[:id])
  end

  def player
    @person = Person.find(params[:id])
  end

  def coach
    @person = Person.find(params[:id])
  end
end
