class BroadcastMessageJob < ApplicationJob
  queue_as :default
  def perform(message)
      ActionCable.server.broadcast 'otlobchannel_channel' , message
  end
end
