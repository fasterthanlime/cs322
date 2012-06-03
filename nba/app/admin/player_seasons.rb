ActiveAdmin.register PlayerSeason do
  menu :parent => 'Stats'

  index do
    column :year
    column 'team' do |ps|
      team = ps.team
      link_to "#{team.trigram} #{team.name}", admin_team_path(team)
    end
    column 'player' do |ps|
      person = ps.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_person_path(person)
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
