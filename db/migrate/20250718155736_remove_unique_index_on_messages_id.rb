class RemoveUniqueIndexOnMessagesId < ActiveRecord::Migration[8.0]
  def change
    remove_index :messages, :id
  end
end