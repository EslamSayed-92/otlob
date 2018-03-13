class OtlobchannelChannel < ApplicationCable::Channel
  def subscribed
     stream_from "otlobchannel_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
  end
end
