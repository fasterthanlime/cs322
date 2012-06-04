class WelcomeController < ApplicationController
  def index
    @teams_count = Team.count()
    @people_count = Person.count()
    query_name = params[:action]
    rc = ActiveRecord::Base.connection.raw_connection
    @birthday = rc.exec "
SELECT id, firstname, lastname, ROUND((sysdate - birthdate) / 364.24)
FROM people
WHERE to_char(birthdate, 'mm-dd') = to_char(sysdate, 'mm-dd')
    "
  end
end
