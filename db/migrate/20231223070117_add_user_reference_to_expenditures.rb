class AddUserReferenceToExpenditures < ActiveRecord::Migration[7.0]
  def change
    add_reference :expenditures, :user, null: true, foreign_key: true
    add_column :expenditures, :comment, :string
  end
end
