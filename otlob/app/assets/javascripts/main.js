$(function(){
	//= Submit the form of find friend action
	invitedFriend=[]



	$("#findFriend").submit(function(e){
		e.preventDefault();
		fdata = $(this).serialize();
		$.ajax({
			url:"/friendships/find",
			method:"post",
			data:fdata,
			success:function(res){
				$("#notice").text(res.message);
				if(res.error)
					$("#notice").addClass("alert alert-danger")
				else
					$("#notice").addClass("alert alert-success")

			}
		});

	})

	$(".shGroup").click(function(e){
		$.ajax({
			url:"/groups/"+$(this).attr('data')+".json",
			method:"get",
			success:function(res){
				$("#grp").prevAll("legend").text(res.name+" Group");
				$("#curGrp").val(res.id);
				$("#addFriendToGroup").css({'display':'block'});
				$("#grp").html("");
				$.each(res.users, function( index, user ) {
					htmlTxt = "<div id="+user.id+" class='col-3-'><img src="+user.avatar_url+">"
					htmlTxt +="<strong>"+user.name+"</strong>"
					if(res.creator != user.id)
					{
						htmlTxt += "<button onClick='remFriend(this)' data-confirm='Remove "+user.name+" from "+res.name+" group ?' "
						htmlTxt += "group_id='"+res.id+"' user_id='"+user.id+"'>"
	        			htmlTxt += "Remove</button></div>"
        			}
        			else
        			{
        				htmlTxt += " <span class='red'>(Group Admin)</span></div>"
        			}
        			$("#grp").html($("#grp").html()+htmlTxt)
				})

			}
		});

	})

	$("#friends").on("click","p",function(e){
		console.log(e.target)
	})
	$("#addFriendToGroup").submit(function(e){
		e.preventDefault();
		gdata = $(this).serialize();
		$.ajax({
			url:"/groups/addToGroup",
			method:"post",
			data:gdata,
			success: function(res){
				$("#notice").text(res.message);
				if(res.error)
					$("#notice").addClass("alert alert-danger")
				else
					$("#notice").addClass("alert alert-success")
			}
		})
	})
	friends = $('.temp_information').data('friends')
	orderId = $('.temp_information').data('orderId')

	$("#fadd").click(function(e){
		searchTxt = document.getElementById('fsearch').value
		var flag=0
		for (var i =0 ; i < Object.keys(friends).length;i++)
		{
			for (var key in friends[i])
				{
					if(key == 'friend')
					{
						if (searchTxt == friends[i][key])
						{	flag=1
							var id =friends[i]['id']

							if (invitedFriend.includes(id))
								{
									alert("Kindly note that you can't add the same user twice")

								}else 
								{
									console.log(invitedFriend)
									invitedFriend.push(friends[i]['id'])
									document.getElementById('invitedFriend').innerHTML+="<span id="+friends[i]['id']+">"+friends[i]['friend']+"<br /> <img src="+friends[i]['avatar']+ "style='hieght:200 px; width:100 px'><p onclick='deletef("+friends[i]['id']+")'>Delete </p></span>"
								}
						}
					}
					
				}
		}
		if(flag==0)
		{
			alert("Kindly note that there is no friends of you with this name")
		}
	})
	$('#gadd').click(function(e)
	{
		searchTxt = document.getElementById('gsearch').value

	})

	$("#addFaG").click(function(e)
	{
		if (invitedFriend.length!=0)
		{
			friendsArr=invitedFriend.join("")
			alert("submit function works ")
			alert("enterd")
		 	$.ajax({
		 	      method : 'post',
		 	      url : '/orders',
		 	      data: {friends:friendsArr },
		 	      success: function(result){
		 	      		console.log(friendsArr)
		 	      		alert(friendsArr)
		 	        },
		 	       errors: function(result)
		 	       {
		 	       	alert("error")
		 	       }
		 		})
		}else
		{
			e.preventDefault();
			alert("kindly enter the invitation part")
		}
		
	})


})
	function remFriend(e){
		$.ajax({
			url:"/groups/removeFromGroup",
			method:"post",
			data:{gid: $(e).attr('group_id'), uid: $(e).attr('user_id')},

			success: function(res){
				$("#notice").text(res.message);
				if(res.error)
					$("#notice").addClass("alert alert-danger")
				else
					$("#notice").addClass("alert alert-success")
				    console.log(res)
			   	    $( "div" ).remove("#"+res.userfriend.id)



			}
		})
	}
	function deletef(id)
	{
		remove(invitedFriend,id)
		document.getElementById(id).remove();
	}

	function remove(array, element) {
    const index = array.indexOf(element);
    array.splice(index, 1);
}
	function finish(e,data)
	{
		var finish= e.parentNode.parentNode
		console.log(finish)
		console.log(data)
		$.ajax({
           url: '/finish',
           method:"get",
           data: {id: data},
           /**
            * Response from your controller
            */
           success: function(res) {
              alert("hi")
           },
           errors:function(error)
           {
           	alert("error")
           }
        });
	}
		function cancel(e,data)
	{
		var finish= e.parentNode.parentNode
		console.log(finish)
		console.log(data)
		$.ajax({
           url: '/cancel',
           method:"get",
           data: {id: data},
           /**
            * Response from your controller
            */
           success: function(res) {
              alert("hi")
           },
           errors:function(error)
           {
           	alert("error")
           }
        });
	}