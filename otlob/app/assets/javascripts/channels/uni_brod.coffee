App.uni_brod = App.cable.subscriptions.create "UniBrodChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
      console.log(data)
      if data.hasOwnProperty("restaurant")
          orderType = ""
          if (data.mtype is 0)
            orderType = "BreakFast"
          else
            orderType = "Lunch"
          $('#ordershereTest').append "<div class=\"post_wrapper\">
            <h2>#{orderType}</h2>
            <p>From :  #{data.restaurant} </p>
            <p>Ordered By : #{data.user_id} </p>
            <p class=\"date\"> #{data.created_at} ago </p>
          </div>"
      if data.hasOwnProperty("type")
        alert(data["Notification"])
      if data.hasOwnProperty("addedToYourFriend")
        $('#friendshipdiv').append "<p>fatma handle el7ta de</p>"
      if data.hasOwnProperty("adddedToTheGroup")
        alert("user : "+data.adddedToTheGroup.name+" added to the group")





  speak: ->
    @perform 'speak'
