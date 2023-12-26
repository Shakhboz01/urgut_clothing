class CreateCurrencyRates < ActiveRecord::Migration[7.0]
  def change
    create_table :currency_rates do |t|
      t.decimal :rate, precision: 12, scale: 2
      t.datetime :finished_at

      t.timestamps
    end
  end
end
