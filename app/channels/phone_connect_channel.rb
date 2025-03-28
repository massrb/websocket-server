class PhoneConnectChannel < ApplicationCable::Channel
  def subscribed
    puts "SUBSCRIBED to phone channel: \n\n" + params.inspect
    # stream_from "chat_#{params[:room]}"
    stream_from "ChatChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    puts 'speak got DATA:' + data.inspect
    msg = Message.create(data['message'])
    ActionCable.server.broadcast("ChatChannel", msg)
  end
end
