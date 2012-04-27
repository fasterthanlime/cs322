class SearchController < ApplicationController
  def index
    term = "'%#{params[:q]}%'"
    sql = File.read('../queries/search.sql').gsub('?', term)
    @results = ActiveRecord::Base.connection.raw_connection.exec(sql)
  end
end
