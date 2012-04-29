ActiveAdmin.register PlayerStat do
  menu :parent => 'Stats'

  index do
    column :player_season do |ps|
      player_season = ps.player_season
      link_to player_season.name, admin_player_season_path(player_season)
    end
    column :player_season_type do |ps|
      status_tag ps.player_season_type.name, :ok
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
