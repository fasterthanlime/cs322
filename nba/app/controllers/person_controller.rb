class PersonController < ApplicationController
  def index
    @people = Person.find(
      :all,
      :conditions => 'ilkid IS NOT NULL',
      :order => 'lastname, firstname'
    )
  end

  def view
    @person = Person.find(params[:id].to_i)
  end

  def player
    @person = Person.find(params[:id].to_i)
  end

  def coach
    @person = Person.find(params[:id].to_i)
  end
end
