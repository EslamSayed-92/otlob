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
        $("#notificationsOfUser").prepend "<a>#{data["Notification"]}</a>"
        $("#dropDownBtn").css 'background', 'purple'
      if data.hasOwnProperty("addedToYourFriend")
        $('#friendshipdiv').append "
        <tbody>
            <tr>
              <td><img src=\"/assets/missing.png\" alt=\"Missing\"></td>
              <td>#{data.addedToYourFriend.name}</td>
              <td><a href=\"http://localhost:3000/friendships/#{data.friendShip.id}\" data-method=\"delete\" data-confirm=\"Are you sure?\">Unfriend</a></td>
            </tr>
        </tbody>"
      if data.hasOwnProperty("adddedToTheGroup")
          $("#grp").append "
          <div id=\"#{data.adddedToTheGroup.id}\" class=\"col-3-\">
          <img src=\"/assets/missing.png\">
          <strong>#{data.adddedToTheGroup.name}</strong>
          <button onclick=\"remFriend(this)\" data-confirm=\"Remove ahmed from helloWorld group? \" group_id=\"#{data.group.id}\" user_id=\"#{data.adddedToTheGroup.id}\">Remove</button></div>
          "
      if data.hasOwnProperty("RemoveFromYourGroup")
          $("#notificationsOfUser").prepend  "<a> user : #{data.RemoveFromYourGroup.name} Removed from the group</a>"

  speak: ->
    @perform 'speak'
