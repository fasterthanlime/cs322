ActiveAdmin.register TeamSeason do
  menu :parent => 'Stats'

  index do
    column :team do |ts|
      team = ts.team
      link_to team.name, admin_team_path(team)
    end
    column :year
    column :pace
    column :opts
    column :ooreb
    column :odreb
    column :oreb
    column :oasts
    column :osteals
    column :oblocks
    column :opf
    column :ofga
    column :ofgm
    column :ofta
    column :oftm
    column :otpa
    column :otpm
    column :dpts
    column :doreb
    column :ddreb
    column :dreb
    column :dasts
    column :dsteals
    column :dblocks
    column :dpf
    column :dfga
    column :dfgm
    column :dfta
    column :dftm
    column :dtpa
    column :dtpm
    default_actions
  end
end
