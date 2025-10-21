class PhoneConnectChannel < ApplicationCable::Channel
  def subscribed
    puts "📞 [#{connection.uuid}] SUBSCRIBED to PhoneConnectChannel with params: #{params.inspect}\n\n"
    # stream_from "chat_#{params[:room]}"
    stream_from "PhoneConnectChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    puts "💬 [#{connection.uuid}] speak got DATA: #{data.inspect}"
    Message.create(content: data['message'])
    # Broadcasting is now handled in the Message model
  end
end
