ActiveAdmin.register Draft do
  menu :parent => 'Teams'

  index do
    column :team do |draft|
      team = draft.team
      link_to "#{team.trigram} #{team.name}", admin_team_path(team)
    end
    column :year
    column :person do |draft|
      person = draft.person
      ilkid = "(#{person.ilkid})" unless person.nil?
      link_to "#{person.fullname} #{ilkid}", admin_person_path(person)
    end
    column :round
    column :selection
    default_actions
  end
end
