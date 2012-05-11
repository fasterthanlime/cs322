ActiveAdmin.register CoachSeason do
  menu :parent => 'Teams'

  index do
    column :id
    column :team do |ct|
      team = ct.team
      link_to "#{team.trigram} #{team.name}", admin_team_path(team)
    end
    column :coach do |ct|
      person = ct.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_person_path(person)
    end
    column :year
    column :year_order
    column :season_win
    column :season_loss
    column :playoff_win
    column :playoff_loss
    default_actions
  end
end
