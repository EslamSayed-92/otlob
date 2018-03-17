App.otlobchannel = App.cable.subscriptions.create "OtlobchannelChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (message) ->
    # empty

  speak: ->
    @perform 'speak'
