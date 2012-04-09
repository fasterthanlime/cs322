# -*- coding: utf-8 -*-
require 'csv'

namespace :import do
  desc "Import teams data from the CSV"
  task :teams => :environment do
    text = File.read('../dataset/teams.csv')
    csv = CSV.parse(text, :headers => true)

    ['NOR', 'NYJ'].each do |trigram|
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

  desc "Drop all data"
  task :drop => :environment do
    Team.delete_all
    Person.delete_all
    Location.delete_all
    Draft.delete_all
  end

  desc "All, remove everything and starts over"
  task :all => :environment do
    ["drop",
     "teams",
     "team_stats",
     "coaches",
     "players",
     "drafts"
    ].each do |t|
      puts
      puts "rake import:#{t}"
      puts
      Rake::Task["import:#{t}"].invoke
    end
  end
end
