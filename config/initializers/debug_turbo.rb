module Turbo
  module Broadcastable
    def broadcast_append_to(...)
      raise "⚠️ broadcast_append_to unexpectedly called!"
    end
  end
end

Turbo::Broadcasts.configure do |config|
  config.unique_index_required = false
end if defined?(Turbo::Broadcasts)