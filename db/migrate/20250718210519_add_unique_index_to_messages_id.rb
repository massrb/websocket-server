class AddUniqueIndexToMessagesId < ActiveRecord::Migration[8.0]
  def change
    add_index :messages, :id, unique: true, name: 'index_messages_on_id_unique'
  end
end
