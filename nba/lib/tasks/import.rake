# -*- coding: utf-8 -*-
=begin

This is maybe the most resource consuming tool to import CSV files into a
database. But we don't care… young people have time to wait. Right?

For better and quicker tool: use `sqlldr`

TODO:
 - unify similar import tasks
 - follow the stinky donkey

=end
require 'csv'

namespace :import do
  desc "Import teams data from the CSV"
  task :teams => :environment do
    text = File.read('../dataset/teams.csv')
    csv = CSV.parse(text, :headers => true)

    # TOT from coaches
    # NYJ from drafts
    # TOT, PHW, SL1 from player regular season
    # SAN from player playoff
    %w(NOR NYJ TOT PHW SL1 SAN NEW).each do |trigram|
      Team.create(
        :trigram => trigram,
        :location => 'unknown',
        :name => 'unknown'
      )
    end

    csv.each do |row|
      # because it starts with sharp
      row["team"] = row[0]
      puts "Adding #{row["team"]}: " + Team.create(
        :trigram => row["team"],
        :location => row["location"],
        :name => row["name"],
      ).to_s
    end
  end

  desc "Import team stats from the CSV"
  task :team_stats => :environment do
    text = File.read('../dataset/team_season.csv')
    csv = CSV.parse(text, :headers => true)

    csv.each do |row|
      row["team"] = row[0]
      team = Team.find_by_trigram(row["team"])
      league = League.find_by_name("#{row["leag"]}BA")
      ts = TeamSeason.create(
         :team => team,
         :year => row["year"],
         :league => league,
         :won => row["won"],
         :pace => row["pace"],
         :lost => row["lost"]
      )
      os = Stat.create(
        :pts => row["o_pts"],
        :oreb => row["o_oreb"],
        :dreb => row["o_dreb"],
        :reb => row["o_reb"],
        :asts => row["o_asts"],
        :steals => row["o_steals"],
        :blocks => row["o_blocks"],
        :turnovers => row["o_turnovers"],
        :tpf => row["o_tpf"],
        :fga => row["o_fga"],
        :fgm => row["o_fgm"],
        :ftm => row["o_ftm"],
        :tpa => row["o_tpa"],
        :tpm => row["o_tpm"]
      )
      ds = Stat.create(
        :pts => row["d_pts"],
        :oreb => row["d_oreb"],
        :dreb => row["d_dreb"],
        :reb => row["d_reb"],
        :asts => row["d_asts"],
        :steals => row["d_steals"],
        :blocks => row["d_blocks"],
        :turnovers => row["d_turnovers"],
        :tpf => row["d_tpf"],
        :fga => row["d_fga"],
        :fgm => row["d_fgm"],
        :ftm => row["d_ftm"],
        :tpa => row["d_tpa"],
        :tpm => row["d_tpm"]
      )
      ots = TeamStat.create(
        :team_stat_tactique => TeamStatTactique.find_by_name("Offensive"),
        :stat => os,
        :team_season => ts
      )
      dts = TeamStat.create(
        :team_stat_tactique => TeamStatTactique.find_by_name("Defensive"),
        :stat => ds,
        :team_season => ts
      )
      puts ts
    end
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
          :person => p,
          :season_win => row["season_win"],
          :season_loss => row["season_loss"],
          :playoff_win => row["playoff_win"],
          :playoff_loss => row["playoff_loss"],
        )
        puts " " + c.to_s
      end

      t = Team.find_by_trigram(row["team"])
      unless t.nil? then
        ct = CoachesTeam.create(
          :coach => c,
          :team => t,
          :year => row["year"],
          :year_order => row["year_order"]
        )
        puts "  " + ct.to_s
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
        raise "#{row["team"]} not found"
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
        :turnovers => row["turnover"],
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

      p = Person.find_by_ilkid(row["ilkid"])
      t = Team.find_by_trigram(row["team"])
      if t.nil? then
        raise "#{row["team"]} not found"
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
        :turnovers => row["turnover"],
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

      if row["ilkid"] == "NULL" then
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

      t = Team.find_by_trigram(row["team"])

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
