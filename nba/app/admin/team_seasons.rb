ActiveAdmin.register TeamSeason do
  menu :parent => 'Seasons'

  index do
    column :year
    column 'team' do |ts|
      team = ts.team
      link_to "#{team.trigram} #{team.name}", admin_team_path(team)
    end
    column :won
    column :pace
    column :lost
    default_actions
  end
end
