ActiveAdmin.register PlayerAllstar do
  menu :parent => 'Stats'

  index do
    column :player do |pas|
      person = pas.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_person_path(person)
    end
    column :year
    column :conference do |pas|
      link_to pas.conference.name, admin_conference_path(pas.conference)
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
