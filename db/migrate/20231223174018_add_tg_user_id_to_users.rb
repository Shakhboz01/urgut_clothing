class AddTgUserIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :telegram_chat_id, :string
    add_column :users, :string, :string
  end
end
