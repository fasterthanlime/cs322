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

  def g
    fetch_results
  end

  def h
    fetch_results
  end

  def i
    fetch_results
  end

  def j
    fetch_results
  end

  def k
    fetch_results
  end

  def l
    fetch_results
  end

  def m
    fetch_results
  end

  def n
    fetch_results
  end

  def o
    fetch_results
  end

  def p
    fetch_results
  end

  def q
    fetch_results
  end

  def r
    fetch_results
  end

  def s
    fetch_results
  end

  def t
    fetch_results
  end

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
