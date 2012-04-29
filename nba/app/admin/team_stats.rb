ActiveAdmin.register TeamStat do
  menu :parent => 'Stats'

  index do
    column :team do |ts|
      team = ts.team
      link_to team.name, admin_team_path(team)
    end
    column :year
    column :team_stat_tactique do |ts|
      status_tag ts.team_stat_tactique.name, :ok
    end
    column :stat do |ts|
      stat = ts.stat
      link_to "#" + stat.id.to_s, admin_stat_path(stat)
    end
    column :pace
    default_actions
  end
end
