class SearchController < ApplicationController
  def index
    if params[:q] then
      term = "'%#{params[:q]}%'"
      sql = File.read('../queries/search.sql').gsub('?', term)
      @results = ActiveRecord::Base.connection.raw_connection.exec(sql)
    end
  end
end
