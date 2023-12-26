class CreateTeamServices < ActiveRecord::Migration[7.0]
  def change
    create_table :team_services do |t|
      t.references :sale_from_service, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.decimal :total_price, precision: 17, scale: 2, default: 0
      t.integer :team_fee, default: 30
      t.decimal :team_portion, precision: 17, scale: 2, default: 0
      t.decimal :company_portion, precision: 17, scale: 2, default: 0
      t.references :user, null: true, foreign_key: true
      t.string :comment

      t.timestamps
    end
  end
end
