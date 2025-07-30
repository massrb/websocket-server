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

    # Render HTML manually (for raw ActionCable broadcast)
    html = ApplicationController.render(
      partial: "messages/message",
      locals: { message: self }
    )

    # Broadcast using ActionCable
    ActionCable.server.broadcast("PhoneConnectChannel", { content: html })
  end
end

