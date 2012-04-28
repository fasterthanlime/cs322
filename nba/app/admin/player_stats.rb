ActiveAdmin.register PlayerStat do
  menu :parent => 'Stats'

  index do
    column :player_season do |ps|
      player_season = ps.player_season
      link_to player_season.name, admin_team_season_path(player_season)
    end
    column :player_season_type do |ps|
      ps.player_season_type.name
    end
    column :gp
    column :minutes
    column :stat do |ps|
      stat = ps.stat
      link_to "#" + stat.id.to_s, admin_stat_path(stat)
    end
    default_actions
  end
end
