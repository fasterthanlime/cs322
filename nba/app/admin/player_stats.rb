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
    column :turnovers
    column :pts
    column :oreb
    column :dreb
    column :reb
    column :asts
    column :steals
    column :blocks
    column :pf
    column :fga
    column :fgm
    column :fta
    column :ftm
    column :tpa
    column :tpm
    default_actions
  end
end
