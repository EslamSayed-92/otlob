class UniBrodChannel < ApplicationCable::Channel
  def subscribed
      stream_from "uni_brod_#{current_user.id}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
  end
end
