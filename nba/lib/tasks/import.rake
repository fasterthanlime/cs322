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
  def sqlldr (csv, table, fields, bad=nil, skip=1)
    control = '.control.txt'
    config = Rails.configuration.database_configuration[Rails.env]
    connstring = "#{config["username"]}/#{config["password"]}@//#{config["host"]}:#{config["port"]}/#{config["database"]}"

    c = File.open(control, 'w+')
    c.write "
LOAD DATA INFILE '#{csv}'
TRUNCATE
INTO TABLE #{table}
FIELDS TERMINATED BY ','
(#{fields.join(', ')})
"

    c.close

    cmd = "sqlldr userid=#{connstring} control=#{control}"
    cmd += " bad=#{bad}" unless bad.nil?
    cmd += " skip=#{skip}" unless skip.nil?
    puts cmd
    system cmd
    File.delete(control)
  end

  desc "Import teams data from the CSV"
  task :teams => :environment do
    conn = ActiveRecord::Base.connection.raw_connection
    csv = '../dataset/teams.csv'
    tmp = 'temp_teams'
    fields = %w(team location name leag)

    conn.exec "CREATE TABLE #{tmp} (#{fields.join(' VARCHAR2(31), ')} VARCHAR2(31))"

    sqlldr(csv, tmp, fields)
    total = conn.exec "
INSERT INTO teams (id, trigram, location, name, league_id)
  SELECT teams_seq.NEXTVAL, tt.team trigram, location, tt.name, l.id league_id
  FROM #{tmp} tt, leagues l
  WHERE SUBSTR(tt.leag, 0, 1) = SUBSTR(l.name, 0, 1)
"
    conn.exec "DROP TABLE #{tmp} PURGE"
    puts "#{total} teams inserted"

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
    conn = ActiveRecord::Base.connection.raw_connection
    csv = '../dataset/team_season.csv'
    tmp = 'temp_seasons'
    fields = %w(team year leag o_fgm o_fga o_ftm o_fta o_oreb o_dreb o_reb
                o_asts o_pf o_stl o_to o_blk o_3pm o_3pa o_pts d_fgm d_fga
                d_ftm d_fta d_oreb d_dreb d_reb d_asts d_pf d_stl d_to d_blk
                d_3pm d_3pa d_pts pace won lost)

    conn.exec "
CREATE TABLE #{tmp} (#{fields.join(' VARCHAR2(31), ')} VARCHAR2(31))
"

    sqlldr(csv, tmp, fields)
    total = conn.exec "
INSERT ALL
  INTO stats (id, pts, oreb, dreb, reb, asts, steals, blocks, pf, fga, fgm, ftm, fta, tpa, tpm)
  VALUES (2 * stats_seq.NEXTVAL - 1, o_pts, o_oreb, o_dreb, o_reb, o_asts, o_stl, o_blk, o_pf, o_fga, o_fgm, o_ftm, o_fta, o_3pa, o_3pm)
  INTO stats (id, pts, oreb, dreb, reb, asts, steals, blocks, pf, fga, fgm, ftm, fta, tpa, tpm)
  VALUES (2 * stats_seq.CURRVAL, d_pts, d_oreb, d_dreb, d_reb, d_asts, d_stl, d_blk, d_pf, d_fga, d_fgm, d_ftm, d_fta, d_3pa, d_3pm)
  INTO team_stats (id, stat_id, team_id, year, team_stat_tactique_id, pace)
  VALUES (2 * team_stats_seq.NEXTVAL - 1, 2 * team_stats_seq.CURRVAL - 1, id, year, #{TeamStatTactique::OFFENSIVE}, pace)
  INTO team_stats (id, stat_id, team_id, year, team_stat_tactique_id)
  VALUES (2 * team_stats_seq.CURRVAL, 2 * team_stats_seq.CURRVAL, id, year, #{TeamStatTactique::DEFENSIVE})
  SELECT *
  FROM #{tmp} t
  JOIN teams ON teams.trigram = SUBSTR(t.team, 0, 3)
"

    # fix the sequences (since we multiplied by 2 right above)
    conn.exec "SELECT stats_seq.NEXTVAL FROM #{tmp}"
    conn.exec "SELECT team_stats_seq.NEXTVAL FROM #{tmp}"
    puts "#{total/2} team_stats inserted"

    conn.exec "DROP TABLE #{tmp} PURGE"
  end

  desc "Import coaches data from the CSV"
  task :coaches => :environment do
    text = File.read('../dataset/coaches_data.csv')
    csv = CSV.parse(text, :headers => true)

    csv.each do |row|
      # One of the coach contains a non-breaking space (nbsp).
      row["coachid"] = row[0].tr(" ", " ").strip
      row["firstname"].strip!
      row["lastname"].strip!
      p = Person.where(
        :ilkid => row["coachid"],
        :firstname => row["firstname"],
        :lastname => row["lastname"]
      )
      if p.empty? then
        p = Person.create(
          :ilkid => row["coachid"],
          :firstname => row["firstname"],
          :lastname => row["lastname"]
        )
        puts p
      else
        p = p[0]
      end

      c = Coach.find_by_person_id(p.id.to_i)

      if c.nil? then
        c = Coach.create(
          :person => p
        )
        puts " " + c.to_s
      end

      t = Team.find_by_trigram(row["team"])
      unless t.nil? then
        cs = CoachSeason.create(
          :coach => c,
          :team => t,
          :year => row["year"],
          :year_order => row["year_order"],
          :season_win => row["season_win"],
          :season_loss => row["season_loss"],
          :playoff_win => row["playoff_win"],
          :playoff_loss => row["playoff_loss"],
        )
        puts "  " + cs.to_s
      else
        raise "Team not found! #{row["team"]}"
      end
    end
  end

  desc "Import players data from the CSV"
  task :players => :environment do
    text = File.read('../dataset/players.csv')
    csv = CSV.parse(text, :headers => true)

    csv.each do |row|
      row["ilkid"] = row[0]

      p = Person.find_by_ilkid(row["ilkid"])
      if p.nil? then
        p = Person.create(
          :ilkid => row["ilkid"],
          :firstname => row["firstname"],
          :lastname => row["lastname"]
        )
        puts p
      end

      # One foot is 12 inches
      height = row["h_feet"].to_i * 12 + row["h_inches"].to_i

      pl = Player.create(
        :person => p,
        :position => row["position"],
        :height => height,
        :weight => row["weight"],
        :birthdate => row["birthdate"]
      )
      puts " " + pl.to_s
    end
  end

  desc "Import regular season stats from the CSV"
  task :regular_seasons => :environment do
    text = File.read('../dataset/player_regular_season.csv')
    csv = CSV.parse(text, :headers => true)

    regular = PlayerSeasonType.find_by_name("Regular")

    csv.each do |row|
      row["ilkid"] = row[0]

      p = Person.find_by_ilkid(row["ilkid"])
      t = Team.find_by_trigram(row["team"])
      if t.nil? then
        raise "Team not found! #{row["team"]}"
      end
      ps = PlayerSeason.create(
        :player => p.player,
        :team => t,
        :year => row["year"]
      )
      s = Stat.create(
        :pts => row["pts"],
        :oreb => row["oreb"],
        :dreb => row["dreb"],
        :reb => row["reb"],
        :asts => row["asts"],
        :steals => row["stl"],
        :blocks => row["blk"],
        :tpf => row["pf"],
        :fga => row["fga"],
        :fgm => row["fgm"],
        :ftm => row["ftm"],
        :tpa => row["tpa"],
        :tpm => row["tpm"]
      )
      stat = PlayerStat.create(
        :stat => s,
        :player_season => ps,
        :player_season_type => regular,
        :turnovers => row["turnover"],
        :gp => row["gp"],
        :minutes => row["minutes"]
      )
      puts ps
    end
  end

  desc "Import playoff season stats from the CSV"
  task :playoffs => :environment do
    text = File.read('../dataset/player_playoffs.csv')
    csv = CSV.parse(text, :headers => true)

    playoff = PlayerSeasonType.find_by_name("Playoff")

    csv.each do |row|
      row["ilkid"] = row[0]
      row["team"] = row["team"].upcase

      p = Person.find_by_ilkid(row["ilkid"])
      t = Team.find_by_trigram(row["team"])
      if t.nil? then
        raise "Team not found! #{row["team"]}"
      end
      ps = PlayerSeason.find(:first, :conditions => "
        player_id = #{p.player.id.to_i} AND
        team_id = #{t.id.to_i} AND
        year = #{row["year"]}
      ")
      if ps.nil? then
        ps = PlayerSeason.create(
          :player => p.player,
          :team => t,
          :year => row["year"]
        )
      end
      s = Stat.create(
        :pts => row["pts"],
        :oreb => row["oreb"],
        :dreb => row["dreb"],
        :reb => row["reb"],
        :asts => row["asts"],
        :steals => row["stl"],
        :blocks => row["blk"],
        :tpf => row["pf"],
        :fga => row["fga"],
        :fgm => row["fgm"],
        :ftm => row["ftm"],
        :tpa => row["tpa"],
        :tpm => row["tpm"]
      )
      stat = PlayerStat.create(
        :stat => s,
        :player_season => ps,
        :player_season_type => playoff,
        :turnovers => row["turnover"],
        :gp => row["gp"],
        :minutes => row["minutes"]
      )
      puts ps
    end
  end

  desc "Import all stars season stats from the CSV"
  task :allstars => :environment do
    text = File.read('../dataset/player_allstar.csv')
    csv = CSV.parse(text, :headers => true)

    csv.each do |row|
      row["ilkid"] = row[0]

      # Fix a buggy ilkid
      if (row["ilkid"] == "JOHNSMA01" and row["firstname"] == "Marques") then
        row["ilkid"] = "JOHNSMA02"
      end
      # Ignore this particular entry
      if (row["ilkid"] == "THOMPDA01" and row["year"] == "1982" and row["tpm"] == "NULL") then
        next
      end
      p = Person.find_by_ilkid(row["ilkid"])
      pl = p.player

      if pl.nil? then
        raise "#{row["ilkid"]} our model suck donkey balls"
      end
      s = Stat.create(
        :pts => row["pts"],
        :oreb => row["oreb"],
        :dreb => row["dreb"],
        :reb => row["reb"],
        :asts => row["asts"],
        :steals => row["stl"],
        :blocks => row["blk"],
        :turnovers => row["turnover"],
        :tpf => row["pf"],
        :fga => row["fga"],
        :fgm => row["fgm"],
        :ftm => row["ftm"],
        :tpa => row["tpa"],
        :tpm => row["tpm"]
      )
      c = Conference.find_by_name(row["conference"] == "west" ?
        "Western" :
        "Eastern"
      )
      pa = PlayerAllstar.create(
        :stat => s,
        :player => pl,
        :conference => c,
        :year => row["year"],
        :gp => row["gp"],
        :minutes => row["minutes"]
      )
      puts pa
    end
  end


  desc "Import drafts data from the CSV"
  task :drafts => :environment do
    text = File.read('../dataset/draft.csv')
    csv = CSV.parse(text, :headers => true)

    csv.each do |row|
      row["draft_year"] = row[0]

      if row["ilkid"].nil? or row["ilkid"].strip.empty? or row["ilkid"] == "NULL" then
        p = Person.create(
          :firstname => row["firstname"],
          :lastname => row["lastname"]
        )
        puts p
      else
        p = Person.find_by_ilkid(row["ilkid"])
        if p.nil? then
          p = Person.create(
            :ilkid => row["ilkid"],
            :firstname => row["firstname"],
            :lastname => row["lastname"]
          )
          puts p
        end
      end

      if p.player.nil? then
        # FIXME: because the position is mandatory, I put '0'
        pl = Player.create(
          :person => p,
          :position => '0'
        )
        puts " " + pl.to_s
      else
        pl = p.player
      end

      c = Location.find_by_name(row["draft_from"])
      if c.nil? then
        c = Location.create(
          :name => row["draft_from"]
        )
        puts " " + c.to_s
      end

      l = League.find_by_name("#{row["leag"]}BA")
      if l.nil? then
        raise "League not found! #{row["leag"]}BA"
      end

      t = Team.find_by_trigram_and_league_id(row["team"], l.id)
      if t.nil? then
        raise "Team not found! #{row["team"]}"
      end


      d = Draft.create(
        :player => pl,
        :team => t,
        :location => c,
        :year => row["draft_year"],
        :selection => row["selection"],
        :round => row["draft_round"]
      )
      puts "  " + d.to_s
    end
  end

  desc "All, remove everything and starts over"
  task :all => :environment do
    %w(
      teams team_stats coaches players drafts regular_seasons playoffs allstars
    ).each do |t|
      puts
      puts "rake import:#{t}"
      puts
      Rake::Task["import:#{t}"].invoke
    end
  end
end
