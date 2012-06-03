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
    query_name = params[:action]
    rc = ActiveRecord::Base.connection.raw_connection

    xxxes = [1000, 1000, 1000, 1000, 700, 700]
    yyyes = [70,   60,   50,   55,   55,  45]

    @values = (params[:values] || 0).to_i
    @xxx = xxxes[@values]
    @yyy = yyyes[@values]

    @sql = File.read("../queries/basic_#{query_name}.sql")
    @sql.split(";").slice(0..-2).each_with_index { |query, i|
      query.sub!(':XXX', @xxx.to_s).sub!(':YYY', @yyy.to_s) if i == 3
      @results = rc.exec(query)
    }
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
    query_name = params[:action]
    rc = ActiveRecord::Base.connection.raw_connection

    types = ["pts", "rebs", "blocks"]

    @values = (params[:values] || 0).to_i
    @type = types[@values]

    @sql = File.read("../queries/basic_#{query_name}.sql")
    @sql.split(";").slice(0..-2).each_with_index { |query, i|
      query.sub!(':TYPE', @type) if i == 5
      @results = rc.exec(query)
    }
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
