class AddPrimaryKeyToMessages < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TABLE messages ADD PRIMARY KEY (id);"
  end
end