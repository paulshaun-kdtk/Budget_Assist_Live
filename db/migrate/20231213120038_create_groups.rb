class CreateGroups < ActiveRecord::Migration[7.1]
    def change
      create_table :groups do |t|
        t.string :name
        t.string :icon, null: true
        t.string  :user
  
        t.timestamps
      end
    end
  end
  