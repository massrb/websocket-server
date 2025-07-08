class Message < ApplicationRecord
  after_create_commit -> {
    broadcast_append_to "messages", target: "messages", partial: "messages/message"
  }
end
