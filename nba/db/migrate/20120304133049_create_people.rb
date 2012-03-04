class CreatePeople < ActiveRecord::Migration
  def up
    create_table :people do |t|
      t.string :ilkid, :unique => true, :null => false, :limit => 9
      t.string :firstname
      t.string :lastname
      t.timestamps
    end
  end

  def down
    drop_table :people
  end
end
