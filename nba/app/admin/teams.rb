ActiveAdmin.register Team do
  index do
    column :id
    column :trigram
    column :name
    column :location
    column 'League' do |team|
      league = team.league
      link_to "#{league.name}", admin_league_path(league)
    end
    default_actions
  end
end
