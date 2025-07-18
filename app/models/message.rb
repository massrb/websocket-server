class Message < ApplicationRecord
  after_create_commit :broadcast_message_and_trim_old

  private

  def broadcast_message_and_trim_old
    Rails.logger.debug "Debug: entering broadcast_message_and_trim_old"
    Rails.logger.debug "Debug: message = #{self.inspect}"
    Rails.logger.debug "Debug: message id = #{self.id}"

    broadcast_append_to "messages", target: "messages", 
                        partial: "messages/message", 
                        locals: { message: self }, unique_by: :primary_key


    total = Message.count
    if total > 200
      # Get oldest message IDs to delete
      excess_ids = Message.order(id: :asc).limit(total - 200).pluck(:id)
      Message.where(id: excess_ids).delete_all
    end
  end
end
