class CreateDailyTransactionReports < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_transaction_reports do |t|
      t.decimal :income_in_usd, precision: 18, scale: 2
      t.decimal :income_in_uzs, precision: 18, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
