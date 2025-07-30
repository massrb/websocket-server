class PhoneConnectChannel < ApplicationCable::Channel
  def subscribed
    puts "SUBSCRIBED to phone channel: \n\n" + params.inspect
    # stream_from "chat_#{params[:room]}"
    stream_from "PhoneConnectChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    puts 'speak got DATA:' + data.inspect
    Message.create(data['message'])
    # Broadcasting is now handled in the Message model
  end
end
