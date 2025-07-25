class Message < ApplicationRecord
  # self.broadcasts = false
  # broadcasts_to 'messages' # disables auto-broadcast
  # self.broadcasts = false
  after_create_commit :broadcast_message_and_trim_old

  def turbo_stream_name
    "message_#{id || SecureRandom.hex(4)}"
  end

  def broadcast_stream_name
    "messages"
  end

=begin
  def broadcast_append_to(*args)
    Rails.logger.error "❌ broadcast_append_to was called — NOT from your custom code!"
    raise "broadcast_append_to call blocked"
  end
=end

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

    rendered_message = ApplicationController.render(
      partial: "messages/message",
      locals: { message: self }
    )

    turbo_stream_payload = <<~STREAM
      <turbo-stream action="append" target="messages">
        <template>
          #{ApplicationController.render(
            partial: "messages/message",
            locals: { message: self }
          )}
        </template>
      </turbo-stream>
    STREAM

    ActionCable.server.broadcast("messages", turbo_stream_payload)

    # broadcast_append_to "messages", target: "messages", 
    #                    partial: "messages/message", 
    #                    locals: { message: self } # , unique_by: :id

    # Turbo::StreamsChannel.broadcast_append_to(
    #   "messages",
    #  target: "messages",
    #  partial: "messages/message",
    #  locals: { message: self }
    # )                    

    total = Message.count
    if total > 200
      # Get oldest message IDs to delete
      excess_ids = Message.order(id: :asc).limit(total - 200).pluck(:id)
      Message.where(id: excess_ids).delete_all
    end
  end
end
