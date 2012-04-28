ActiveAdmin.register PlayerSeason do
  menu :parent => 'Seasons'

  index do
    column :year
    column 'team' do |ps|
      team = ps.team
      link_to "#{team.trigram} #{team.name}", admin_team_path(team)
    end
    column 'player' do |ps|
      player = ps.player
      person = player.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_player_path(player)
    end
    default_actions
  end
end
