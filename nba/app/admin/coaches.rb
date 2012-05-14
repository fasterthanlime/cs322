ActiveAdmin.register Coach do
  menu :parent => 'People'

  index do
    column :id
    column 'Person' do |coach|
      person = coach.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_person_path(person)
    end
    column :season_count
    column :season_win
    column :season_loss
    column :playoff_win
    column :playoff_loss
    default_actions
  end
end
