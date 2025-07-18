
# stale schema cache on render.com ? 
# try to fix
class RecreateIndexOnMessagesId < ActiveRecord::Migration[8.0]
  def change
    remove_index :messages, name: "index_messages_on_id", if_exists: true
    add_index :messages, :id, unique: true, name: "index_messages_on_id"
  end
end
