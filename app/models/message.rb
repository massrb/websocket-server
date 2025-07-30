class Message < ApplicationRecord
  after_create_commit :broadcast_message_and_cleanup

  private

  def broadcast_message_and_cleanup
    # Cleanup old messages
    total = Message.count
    Rails.logger.debug "DEBUG total messages: #{total}"

    if total > 200
      Rails.logger.debug "DEBUG clean up messages"
      Message.order(id: :asc).limit(total - 200).destroy_all
    end

    # Broadcast simplified JSON (id and content only)
    ActionCable.server.broadcast("PhoneConnectChannel", {
      id: self.id,
      content: self.content
    })
  end
end

