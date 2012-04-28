ActiveAdmin.register TeamStat do
  menu :parent => 'Stats'

  index do
    column :team_season do |ts|
      team_season = ts.team_season
      link_to team_season.name, admin_team_season_path(team_season)
    end
    column :team_stat_tactique do |ts|
      ts.team_stat_tactique.name
    end
    column :stat do |ts|
      stat = ts.stat
      link_to "#" + stat.id.to_s, admin_stat_path(stat)
    end
    default_actions
  end
end
