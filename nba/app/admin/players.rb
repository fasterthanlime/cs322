ActiveAdmin.register Player do
  menu :parent => 'People'
  scope :all, :default => true
end
