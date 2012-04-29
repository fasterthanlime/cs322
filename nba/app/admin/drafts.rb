ActiveAdmin.register Draft do
  menu :parent => 'Teams'

  index do
    column :team do |draft|
      team = draft.team
      link_to "#{team.trigram} #{team.name}", admin_team_path(team)
    end
    column :year
    column :player do |draft|
      player = draft.player
      person = player.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_player_path(player)
    end
    column :round
    column :selection
    default_actions
  end
end