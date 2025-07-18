class Message < ApplicationRecord
  after_create_commit :broadcast_message_and_trim_old

  private

  def broadcast_message_and_trim_old
    broadcast_append_to "messages", target: "messages", partial: "messages/message"

    total = Message.count
    if total > 200
      # Get oldest message IDs to delete
      excess_ids = Message.order(id: :asc).limit(total - 200).pluck(:id)
      Message.where(id: excess_ids).delete_all
    end
  end
end
