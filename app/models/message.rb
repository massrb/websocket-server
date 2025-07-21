class Message < ApplicationRecord
  after_create_commit :broadcast_message_and_trim_old

  private

  def broadcast_message_and_trim_old
    Rails.logger.debug "=== INDEX DEBUG START ==="
    Rails.logger.debug "Debug: entering broadcast_message_and_trim_old"
    Rails.logger.debug "Debug: message = #{self.inspect}"
    Rails.logger.debug "Debug: message id = #{self.id}"
    ActiveRecord::Base.connection.indexes(:messages).each do |index|
      Rails.logger.debug "Index: #{index.name}, Columns: #{index.columns}, Unique: #{index.unique}"
    end
    Message.connection.indexes("messages").each do |index|
      puts "message conenctions; Name: #{index.name}, Unique: #{index.unique}, Columns: #{index.columns.inspect}"
    end

    puts 'model primary key:' + Message.primary_key.inspect

    primary_key = Message.connection.primary_key('messages')
    Rails.logger.debug "Primary key for messages table: #{primary_key.inspect}"

    Rails.logger.debug "=== INDEX DEBUG END ==="

    broadcast_append_to "messages", target: "messages", 
                        partial: "messages/message", 
                        locals: { message: self }, unique_by: :id

    total = Message.count
    if total > 200
      # Get oldest message IDs to delete
      excess_ids = Message.order(id: :asc).limit(total - 200).pluck(:id)
      Message.where(id: excess_ids).delete_all
    end
  end
end
