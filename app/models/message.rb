class Message < ApplicationRecord
  after_create_commit :broadcast_message_and_trim_old

  private

  def broadcast_message_and_trim_old
    # Broadcast the newly created message
    broadcast_append_to "messages", target: "messages", partial: "messages/message"

    # Trim oldest messages, keeping the latest 200 only
    trim_old_messages
  end

  def trim_old_messages
    # Count messages and only trim if there are too many
    excess_count = Message.count - 200
    return if excess_count <= 0

    # Delete the oldest records beyond the latest 200
    Message.order(created_at: :asc).limit(excess_count).delete_all
  end
end

