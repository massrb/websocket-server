module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      # puts "⚡ Origin: #{request.origin.inspect}"
      # Add your connection logic if needed
    end
  end
end
