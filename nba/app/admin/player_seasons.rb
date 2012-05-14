ActiveAdmin.register PlayerSeason do
  menu :parent => 'Teams'

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
    default_actions
  end
end
