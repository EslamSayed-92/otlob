App.otlobchannel = App.cable.subscriptions.create "OtlobchannelChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (message) ->
    console.log(current_user)
    if message.hasOwnProperty("restaurant")
        orderType = ""
        if (message.mtype is 0)
          orderType = "BreakFast"
        else
          orderType = "Lunch"

        $('#ordershereTest').append "<div class=\"post_wrapper\"  id=\"ordershereTest\">
          <h2>#{orderType}</h2>
          <p>From :  #{message.restaurant} </p>
          <p>Ordered By : #{message.user_id} </p>
          <p class=\"date\"> #{message.created_at} ago </p>
        </div>"
        console.log(message)
    if message.hasOwnProperty("friend_id")
      console.log("friendShip")


  speak: ->
    @perform 'speak'
