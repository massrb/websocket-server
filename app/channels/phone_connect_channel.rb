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
    msg = Message.create(data['message'])

    html = ApplicationController.render(
      partial: "messages/message",
      locals: { message: msg }
    )
    ActionCable.server.broadcast("PhoneConnectChannel", { content: html })
  end
end
