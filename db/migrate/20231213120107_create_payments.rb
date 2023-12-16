class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :name
      t.decimal :amount

      t.references :group, null: true, foreign_key: { to_table: :groups, on_delete: :cascade }
      t.timestamps
    end
  end
end
