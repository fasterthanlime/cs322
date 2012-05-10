ActiveAdmin.register TeamStat do
  menu :parent => 'Stats'

  index do
    column :team do |ts|
      team = ts.team
      link_to team.name, admin_team_path(team)
    end
    column :year
    column :team_stat_tactique do |ts|
      status_tag ts.team_stat_tactique.name, ts.team_stat_tactique_id == 1 ? :ok : :info
    end
    column :pace
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
