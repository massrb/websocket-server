module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid
    def connect
      # puts "⚡ Origin: #{request.origin.inspect}"
      # Add your connection logic if needed
      self.uuid = SecureRandom.uuid
      logger.add_tags 'ActionCable', uuid
      Rails.logger.info "📡 New connection: #{uuid}"
    end
  end
end
