ActiveAdmin.register Person do
  index do
    column :id
    column :ilkid
    column :firstname
    column :lastname
    column 'Player' do |person|
      link_to '#' + person.player.id.to_s, admin_player_path(person.player) unless person.player.nil?
    end
    column 'Coach' do |person|
      link_to '#' + person.coach.id.to_s, admin_coach_path(person.coach) unless person.coach.nil?
    end
    default_actions
  end
end
