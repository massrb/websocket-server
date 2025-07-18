class RemoveDuplicateIndexOnMessagesId < ActiveRecord::Migration[8.0]
  def change
    remove_index :messages, name: "index_messages_on_id_unique"
  end
end
