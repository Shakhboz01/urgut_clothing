class CreateDebtUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :debt_users do |t|
      t.string :name

      t.timestamps
    end
  end
end
