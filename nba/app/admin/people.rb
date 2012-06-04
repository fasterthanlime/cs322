ActiveAdmin.register Person do
  scope :all, :default => true
  scope :has_ilkid do |people|
    people.where('ilkid IS NOT NULL')
  end
  scope :no_ilkid do |people|
    people.where('ilkid IS NULL')
  end
  index do
    column :id
    column :ilkid
    column :firstname
    column :lastname
    column :position
    column :weight
    column :height
    column :birthdate
    default_actions
  end
end
