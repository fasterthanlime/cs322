ActiveAdmin.register CoachSeason do
  menu :parent => 'Teams'
  
  index do
    column :id
    column 'Team' do |ct|
      team = ct.team
      link_to "#{team.trigram} #{team.name}", admin_team_path(team)
    end
    column 'Coach' do |ct|
      coach = ct.coach
      person = coach.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_coach_path(coach)
    end
    column :year
    column :year_order
    default_actions
  end
end
