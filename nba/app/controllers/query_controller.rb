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

  def g; end
  def i; end
  def j; end
  def k; end
  def l; end
  def m; end
  def o; end
  def p; end
  def q; end
  def r; end
  def s; end
  def t; end

  private

  def fetch_results
    query_name = params[:action]
    rc = ActiveRecord::Base.connection.raw_connection

    @sql = File.read("../queries/basic_#{query_name}.sql")
    @sql.split(";").slice(0..-2).each { |query|
      @results = rc.exec(query)
    }
  end

end
