ActiveAdmin.register Player do
  menu :parent => 'People'
  scope :all, :default => true

  index do
    column :id
    column 'Person' do |player|
      person = player.person
      ilkid = "(#{person.ilkid})" if person.ilkid
      link_to "#{person.fullname} #{ilkid}", admin_person_path(person)
    end
    column 'Position' do |player|
      player.position if player.position != '0'
    end
    column :height
    column :weight
    column 'Birthdate' do |player|
      player.birthdate.strftime('%Y-%m-%d') unless player.birthdate.nil?
    end
    default_actions
  end
end
