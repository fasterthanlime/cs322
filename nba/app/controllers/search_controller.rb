class SearchController < ApplicationController
  def index
    @sql = File.read('../queries/search.sql')
    if params[:q] then
      term = "'%#{params[:q]}%'"
      @sql.gsub!('?', term)
      @results = ActiveRecord::Base.connection.raw_connection.exec(@sql)
    end
  end
end
