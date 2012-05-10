ActiveAdmin.register PlayerAllstar do
  menu :parent => 'Stats'

  index do
    column :player do |pas|
      player = pas.player
      person = player.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_player_path(player)
    end
    column :year
    column :conference do |pas|
      link_to pas.conference.name, admin_conference_path(pas.conference)
    end
    column :gp
    column :minutes
    column :turnovers
    column :stat do |pas|
      stat = pas.stat
      link_to "#" + stat.id.to_s, admin_stat_path(stat)
    end
    default_actions
  end
end
