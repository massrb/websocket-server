class ChatController < ApplicationController
  def index
    @messages = Message.order(:id).last(50)
  end
end