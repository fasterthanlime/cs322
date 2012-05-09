# -*- coding: utf-8 -*-
=begin

This is maybe the most resource consuming tool to import CSV files into a
database. But we don't care… young people have time to wait. Right?

For better and quicker tool: use `sqlldr`

TODO:
 - unify similar import tasks (if it ain't broke, don't fix)

=end
require 'csv'

namespace :import do
  def connection
    ActiveRecord::Base.connection.raw_connection
  end

  def connection_string
    c = Rails.configuration.database_configuration[Rails.env]
    "#{c["username"]}/#{c["password"]}@//#{c["host"]}:#{c["port"]}/#{c["database"]}"
  end

  def cleanup (table)
    connection().exec "DROP TABLE #{table} PURGE"
  end

  def sqlldr (csv, table, fields, bad=nil, skip=1)
    control = '.control.txt'
    c = File.open(control, 'w+')

    # Replacing "NULL" with proper NULL hopefully nobody's called that way
    # but... http://stackoverflow.com/q/4456438/122978
    sqlfields = fields.map do |field|
      "#{field} \"DECODE(:#{field}, 'NULL', NULL, :#{field})\""
    end
    c.write "
LOAD DATA INFILE '#{csv}'
TRUNCATE
INTO TABLE #{table}
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(#{sqlfields.join(', ')})
"

    c.close

    type = "VARCHAR2(255)"
    connection().exec "
      CREATE TABLE #{table} (#{fields.join(" #{type}, ")} #{type})
    "
    cmd = "sqlldr userid=#{connection_string} control=#{control}"
    cmd += " bad=#{bad}" unless bad.nil?
    cmd += " skip=#{skip}" unless skip.nil?
    system cmd
    File.delete(control)
  end

  desc ""
  task :schema => :environment do
    conn = connection_string
    ["drop", "schema", "data"].each do |file|
      puts "Loading: #{file}.sql"
      system "sqlplus #{conn} < ../documents/sql/#{file}.sql"
    end
  end

  desc "Import teams data from the CSV"
  task :teams => :environment do
    conn = connection
    csv = '../dataset/teams.csv'
    tmp = 'temp_teams'
    fields = %w(team location name leag)

    sqlldr(csv, tmp, fields)
    total = conn.exec "
INSERT INTO teams (id, trigram, location, name, league_id)
  SELECT teams_seq.NEXTVAL, tt.team trigram, location, tt.name, l.id league_id
  FROM #{tmp} tt, leagues l
  WHERE tt.leag = SUBSTR(l.name, 0, 1)
"
    puts "#{total} teams inserted"
    cleanup(tmp)

    # Fixing the data
    missing_teams = {
      "ABA" => %w(NYJ),
      "NBA" => %w(NEW NOR PHW SAN SL1 TAT TOT)
    }
    missing_teams.each do |league, teams|
      league = League.find_by_name(league)
      teams.each do |trigram|
        puts Team.create(
          :trigram => trigram,
          :league => league
        )
      end
    end
  end

  desc "Import team stats from the CSV"
  task :team_stats => :environment do
    conn = connection
    csv = '../dataset/team_season.csv'
    tmp = 'temp_seasons'
    fields = %w(team year leag o_fgm o_fga o_ftm o_fta o_oreb o_dreb o_reb
                o_asts o_pf o_stl o_to o_blk o_3pm o_3pa o_pts d_fgm d_fga
                d_ftm d_fta d_oreb d_dreb d_reb d_asts d_pf d_stl d_to d_blk
                d_3pm d_3pa d_pts pace won lost)

    # The sequences may already be containing data (initial value being 1)
    stats_offset = -1
    team_stats_offset = -1
    conn.exec("SELECT last_number FROM user_sequences WHERE sequence_name = 'STATS_SEQ'") do |l|
      stats_offset += l[0].to_i
    end
    conn.exec("SELECT last_number FROM user_sequences WHERE sequence_name = 'TEAM_STATS_SEQ'") do |l|
      team_stats_offset += l[0].to_i
    end
    offset = stats_offset - team_stats_offset;

    sqlldr(csv, tmp, fields)
    total = conn.exec "
INSERT ALL
  INTO stats (
    id, pts, oreb, dreb, reb, asts, steals, blocks, pf, fga, fgm, fta, ftm,
    tpa, tpm
  ) VALUES (
    2 * stats_seq.NEXTVAL - 1, o_pts, o_oreb, o_dreb, o_reb, o_asts, o_stl,
    o_blk, o_pf, o_fga, o_fgm, o_fta, o_ftm, o_3pa, o_3pm
  )
  INTO stats (
    id, pts, oreb, dreb, reb, asts, steals, blocks, pf, fga, fgm, fta, ftm,
    tpa, tpm
  ) VALUES (
    2 * stats_seq.CURRVAL, d_pts, d_oreb, d_dreb, d_reb, d_asts, d_stl, d_blk,
    d_pf, d_fga, d_fgm, d_fta, d_ftm, d_3pa, d_3pm
  )
  SELECT *
  FROM #{tmp}
"
    puts "#{total} stats inserted"

    total2 = conn.exec "
INSERT ALL
  INTO team_stats (
    id, stat_id, team_id, year, team_stat_tactique_id, pace
  ) VALUES (
    2 * team_stats_seq.NEXTVAL - 1, #{offset} + 2 * team_stats_seq.CURRVAL - 1,
    team_id, year, #{TeamStatTactique::OFFENSIVE}, pace
  )
  INTO team_stats (
    id, stat_id, team_id, year, team_stat_tactique_id
  ) VALUES (
    2 * team_stats_seq.CURRVAL, #{offset} + 2 * team_stats_seq.CURRVAL, team_id,
    year, #{TeamStatTactique::DEFENSIVE}
  )
  SELECT tmp.*, t.id team_id
  FROM #{tmp} tmp
  JOIN teams t ON t.trigram = tmp.team
  JOIN leagues l ON l.id = t.league_id
  WHERE tmp.leag = SUBSTR(l.name, 0, 1)
"
    puts "#{total2} team_stats inserted"

    # HACK! fix the sequences (since we multiplied by 2 right above)
    conn.exec "
UPDATE #{tmp} SET team = stats_seq.NEXTVAL, year = team_stats_seq.NEXTVAL
"

    cleanup(tmp)
  end

  desc "Import coaches data from the CSV"
  task :coaches => :environment do
    conn = connection
    csv = '../dataset/coaches_career.csv'
    tmp = 'temp_coaches'
    fields = %w(coachid firstname lastname season_win season_loss playoff_win playoff_loss)

    sqlldr(csv, tmp, fields)
    total = conn.exec "
INSERT ALL
  INTO people (
    id, ilkid, firstname, lastname
  ) VALUES (
    people_seq.NEXTVAL, SUBSTR(coachid, 0, 9), firstname, lastname
  )
  INTO coaches (
    id, person_id
  ) VALUES (
    coaches_seq.NEXTVAL, people_seq.CURRVAL
  )
  SELECT *
  FROM #{tmp}
"
    puts "#{total/2} coaches inserted"
    cleanup(tmp)
  end

  desc "Import coach seasons from the CSV"
  task :coach_seasons => :environment do
    conn = connection
    csv = '../dataset/coaches_data.csv'
    tmp = 'temp_coaches'
    fields = %w(coachid year yr_order firstname lastname season_win season_loss
                playoff_win playoff_loss team)

    sqlldr(csv, tmp, fields)
    total = conn.exec "
INSERT INTO coach_seasons (
    id, team_id, coach_id, year, year_order, season_win, season_loss,
    playoff_win, playoff_loss
  )
  SELECT
    coach_seasons_seq.NEXTVAL, t.id, c.id, year, yr_order, season_win,
    season_loss, playoff_win, playoff_loss
  FROM #{tmp} tmp
  JOIN people p ON p.ilkid = SUBSTR(tmp.coachid, 0, 9)
  JOIN coaches c ON c.person_id = p.id
  JOIN teams t ON t.trigram = tmp.team
"

    cleanup(tmp)
    puts "#{total} coach seasons inserted"
  end

  desc "Import players data from the CSV"
  task :players => :environment do
    conn = connection
    csv = '../dataset/players.csv'
    tmp = 'temp_players'
    fields = %w(ilkid firstname lastname position firstseason lastseason h_feet
                h_inches weight college birthdate)

    sqlldr(csv, tmp, fields)

    total = conn.exec "
INSERT INTO people (id, ilkid, firstname, lastname)
  SELECT people_seq.NEXTVAL, ilkid, firstname, lastname
  FROM #{tmp} tmp
  WHERE NOT EXISTS (
    SELECT 1
    FROM people p
    WHERE tmp.ilkid = p.ilkid
  )
"
    puts "#{total} more people inserted"

    total = conn.exec "
INSERT INTO players (id, person_id, position, height, weight, birthdate)
  SELECT
    players_seq.NEXTVAL, p.id, position, (h_feet * 12) + h_inches, weight,
    birthdate
  FROM #{tmp} tmp, people p
  WHERE tmp.ilkid = p.ilkid
"

    puts "#{total} players inserted"
    cleanup(tmp)
  end

  desc "Import regular season stats from the CSV"
  task :regular_seasons => :environment do
    conn = connection
    csv = '../dataset/player_regular_season.csv'
    tmp = 'temp_seasons'
    fields = %w(ilkid year firstname lastname team leag gp minutes pts oreb dreb
                reb asts stl blk turnover pf fga fgm fta ftm tpa tpm)

    sqlldr(csv, tmp, fields)

    total = conn.exec "
INSERT ALL
  INTO player_seasons (
    id, player_id, team_id, year
  ) VALUES (
    player_seasons_seq.NEXTVAL, player_id, team_id, year
  )
  INTO stats (
    id, pts, oreb, dreb, reb, asts, steals, blocks, pf, fga, fgm, fta, ftm,
    tpa, tpm
  ) VALUES (
    stats_seq.NEXTVAL, pts, oreb, dreb, reb, asts, stl, blk, pf, fga, fgm, fta, ftm,
    tpa, tpm
  )
  SELECT tmp.*, pl.id player_id, t.id team_id
  FROM
    #{tmp} tmp, people p, leagues l, players pl, teams t
  WHERE
    p.ilkid = tmp.ilkid AND
    pl.person_id = p.id AND
    t.trigram = tmp.team AND
    t.league_id = l.id AND (
      substr(l.name, 0, 1) = tmp.leag OR
      l.name = 'NBA' AND tmp.team = 'TOT' -- TOT never played in ABA
    )
"

    puts "#{total/2} more stats inserted"

    # The sequences may already be containing data (initial value being 1)
    offset = 0
    conn.exec("SELECT max(id) from stats") do |l|
      offset = l[0].to_i
    end
    offset -= total / 2

    total = conn.exec "
INSERT INTO player_stats (
    id, stat_id, player_season_id, player_season_type_id, turnovers, gp, minutes
  )
  SELECT
    player_stats_seq.NEXTVAL, #{offset} + player_stats_seq.CURRVAL, ps.id,
    #{PlayerSeasonType::REGULAR}, turnover, gp, minutes
  FROM
    #{tmp} tmp, people p, leagues l, players pl, teams t, player_seasons ps
  WHERE
    p.ilkid = tmp.ilkid AND
    pl.person_id = p.id AND
    t.trigram = tmp.team AND
    t.league_id = l.id AND (
      substr(l.name, 0, 1) = tmp.leag OR
      l.name = 'NBA' AND tmp.team = 'TOT' -- TOT never played in ABA
    ) AND
    ps.year = tmp.year AND ps.player_id = pl.id AND ps.team_id = t.id
"
    puts "#{total} player regular seasons inserted"
    cleanup(tmp)
  end

  desc "Import playoff season stats from the CSV"
  task :playoffs => :environment do
    conn = connection
    csv = '../dataset/player_playoffs.csv'
    tmp = 'temp_seasons'
    fields = %w(ilkid year firstname lastname team leag gp minutes pts oreb dreb
                reb asts stl blk turnover pf fga fgm fta ftm tpa tpm)

    sqlldr(csv, tmp, fields)

    total = conn.exec "
INSERT INTO player_seasons (
    id, player_id, team_id, year
  )
  SELECT
    player_seasons_seq.NEXTVAL, pl.id, t.id, year
  FROM
    #{tmp} tmp, people p, leagues l, players pl, teams t
  WHERE
    p.ilkid = tmp.ilkid AND
    pl.person_id = p.id AND
    t.trigram = tmp.team AND
    t.league_id = l.id AND
    substr(l.name, 0, 1) = tmp.leag AND
    NOT EXISTS (
      SELECT 1
      FROM player_seasons ps
      WHERE
        tmp.year = ps.year AND
        pl.id = ps.player_id AND
        t.id = ps.team_id
    )
"
    puts "#{total} more player seasons inserted"

    total = conn.exec "
INSERT INTO stats (
    id, pts, oreb, dreb, reb, asts, steals, blocks, pf, fga, fgm, fta, ftm,
    tpa, tpm
  )
  SELECT
    stats_seq.NEXTVAL, pts, oreb, dreb, reb, asts, stl, blk, pf, fga, fgm, fta, ftm,
    tpa, tpm
  FROM
    #{tmp}
"
    puts "#{total} more stats inserted"

    # The sequences may already be containing data (initial value being 1)
    offset = 0
    conn.exec("SELECT max(id) from stats") do |l|
      offset = l[0].to_i
    end
    conn.exec("SELECT max(stat_id) from player_stats") do |l|
      offset -= l[0].to_i
    end
    offset -= total

    total = conn.exec "
INSERT INTO player_stats (
    id, stat_id, player_season_id, player_season_type_id, turnovers, gp, minutes
  )
  SELECT
    player_stats_seq.NEXTVAL, #{offset} + player_stats_seq.CURRVAL, ps.id,
    #{PlayerSeasonType::PLAYOFF}, turnover, gp, minutes
  FROM
    #{tmp} tmp, people p, leagues l, players pl, teams t, player_seasons ps
  WHERE
    p.ilkid = tmp.ilkid AND
    pl.person_id = p.id AND
    t.trigram = tmp.team AND
    t.league_id = l.id AND
    substr(l.name, 0, 1) = tmp.leag AND
    ps.year = tmp.year AND ps.player_id = pl.id AND ps.team_id = t.id
"
    puts "#{total} player playoff seasons inserted"
    cleanup(tmp)
  end

  desc "Import all stars season stats from the CSV"
  task :allstars => :environment do
    conn = connection
    csv = '../dataset/player_allstar.csv'
    tmp = 'temp_seasons'
    fields = %w(ilkid year firstname lastname conference leag gp minutes pts dreb oreb
                reb asts stl blk turnover pf fga fgm fta ftm tpa tpm)

    sqlldr(csv, tmp, fields)
    total = conn.exec "
INSERT INTO stats (
    id, pts, oreb, dreb, reb, asts, steals, blocks, pf, fga, fgm, fta, ftm,
    tpa, tpm
  )
  SELECT
    stats_seq.NEXTVAL, pts, oreb, dreb, reb, asts, stl, blk, pf, fga, fgm, fta, ftm,
    tpa, tpm
  FROM
    #{tmp}
  WHERE
    ilkid <> 'THOMPDA01' OR year <> '1982' OR tpm IS NOT NULL -- row to ignore
"
    puts "#{total} more stats inserted"

    # The sequences may already be containing data (initial value being 1)
    offset = 0
    conn.exec("SELECT max(id) from stats") do |l|
      offset = l[0].to_i
    end
    offset -= total

    total = conn.exec "
INSERT INTO player_allstars (
    id, stat_id, player_id, conference_id, year, turnovers, gp, minutes
  )
  SELECT
    player_allstars_seq.NEXTVAL, #{offset} + player_allstars_seq.CURRVAL, pl.id,
    c.id, year, turnover, gp, minutes
  FROM
    #{tmp} tmp, people p, players pl, conferences c
  WHERE
    (tmp.ilkid <> 'THOMPDA01' OR tmp.year <> '1982' OR tmp.tpm IS NOT NULL) AND
    (
      p.ilkid = CASE WHEN (tmp.ilkid = 'JOHNSMA01' AND tmp.firstname = 'Marques')
        THEN 'JOHNSMA02'
        ELSE tmp.ilkid
      END
    ) AND
    pl.person_id = p.id AND
    (
      substr(c.name, 0, 4) = tmp.conference OR
      lower(substr(c.name, 0, 4)) = tmp.conference OR
      c.name = 'Western' AND (tmp.conference = 'weset' OR tmp.conference = 'Denver' or tmp.conference = 'AllStars')
      -- AllStars is 1975: https://en.wikipedia.org/wiki/American_Basketball_Association#List_of_ABA_championships
    )
"

    puts "#{total} player allstars seasons inserted"
    cleanup(tmp)
  end

  desc "Import drafts data from the CSV"
  task :drafts => :environment do
    conn = connection
    csv = '../dataset/draft.csv'
    tmp = 'temp_drafts'
    fields = %w(draft_year draft_round selection team firstname lastname ilkid
                draft_from leag)

    sqlldr(csv, tmp, fields)

    total = conn.exec "
INSERT INTO people (id, ilkid, firstname, lastname)
  SELECT people_seq.NEXTVAL, ilkid, firstname, lastname
  FROM (
    SELECT DISTINCT ilkid, firstname, lastname
    FROM #{tmp} tmp
    WHERE
      NOT EXISTS (
        SELECT 1
        FROM people p
        WHERE
          p.ilkid = tmp.ilkid AND
          p.firstname = tmp.firstname AND
          p.lastname = tmp.lastname
      )
  )
"
    puts "#{total} more people inserted"

    total = conn.exec "
INSERT INTO locations (id, name)
  SELECT locations_seq.NEXTVAL, draft_from
  FROM (
    SELECT DISTINCT draft_from
    FROM #{tmp}
  )
"
    puts "#{total} locations inserted"

    total = conn.exec "
INSERT INTO drafts (
    id, person_id, team_id, location_id, year, selection, round
  )
  SELECT
    drafts_seq.NEXTVAL, p.id, t.id, loc.id, tmp.draft_year, tmp.selection,
    tmp.draft_round
  FROM #{tmp} tmp
  JOIN people p ON
    (
      tmp.ilkid = p.ilkid OR
      tmp.ilkid IS NULL AND
      p.ilkid IS NULL
    ) AND
    tmp.firstname = p.firstname AND
    tmp.lastname = p.lastname
  JOIN teams t ON tmp.team = t.trigram
  JOIN leagues l ON
    t.league_id = l.id AND
    tmp.leag = SUBSTR(l.name, 0, 1)
  LEFT JOIN locations loc ON tmp.draft_from = loc.name
"
    puts "#{total} drafts inserted"
    cleanup(tmp)
  end

  desc "All, remove everything and starts over"
  task :all => :environment do
    %w(
      schema teams team_stats coaches coach_seasons players regular_seasons
      playoffs allstars drafts
    ).each do |t|
      puts
      puts "rake import:#{t}"
      puts
      Rake::Task["import:#{t}"].invoke
    end
  end
end
