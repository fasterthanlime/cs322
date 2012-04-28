class QueryController < ApplicationController

  def index

  end

  def a
    fetch_results
  end

  def b
    fetch_results
  end

  def c
    fetch_results
  end

  def d
    fetch_results
  end

  def e
    fetch_results
  end

  def f
    fetch_results
  end

  private
  
  def fetch_results
    query_name = params[:action]
    rc = ActiveRecord::Base.connection.raw_connection

    @sql = File.read("../queries/basic_#{query_name}.sql")
    @sql.split(";").slice(0..-2).each { |query|
      rc.exec(query)
    }

    @results = rc.exec("SELECT * FROM query_#{query_name}")
  end

end
