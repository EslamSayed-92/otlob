$(function(){
	//= Submit the form of find friend action
	invitedFriend=[]
	invitedGroups=[]

	//= add friend form submit action
	$("#findFriend").submit(function(e){
		e.preventDefault();
		fdata = $(this).serialize();
		$.ajax({
			url:"/friendships/find",
			method:"post",
			data:fdata,
			success:function(res){
				$("#notice").text(res.message);
				if(res.error){
					$("#notice").removeClass("alert alert-success")
					$("#notice").addClass("alert alert-danger")
				}else{
					$("#notice").removeClass("alert alert-danger")
					$("#notice").addClass("alert alert-success")
				}

			}
		});

	})

	//= Show Group click action
	$(".shGroup").on("click",function(e){
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

	//= add friend in group form submit action
	$("#addFriendToGroup").submit(function(e){
		e.preventDefault();
		gdata = $(this).serialize();
		$.ajax({
			url:"/groups/addToGroup",
			method:"post",
			data:gdata,
			success: function(res){
				$("#notice").text(res.message);
				if(res.error){
					$("#notice").removeClass("alert alert-success")
					$("#notice").addClass("alert alert-danger")
				}else
					$("#notice").addClass("alert alert-success")
			}
		})
	})

	//= add order form submit action
	$("#addFaG").click(function(e)
	{
		if (invitedFriend.length!=0)
		{
			friendsArr=invitedFriend.join("")
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
		}
		else
		{
			e.preventDefault();
			alert("kindly enter the invitation part")
		}
		
	})


	//= Create Order function
	$("#addOrder").click(function(e){
		e.preventDefault();
		mtype = $("input[name='mtype']:checked").val();
		restaurant = $("#order_restaurant").val(); 
		if(mtype == undefined){
			$("#notice").removeClass("alert alert-success")
			$("#notice").addClass("alert alert-warning")
			$("#notice").text("Please select order type");
		}
		else if(restaurant == ""){
			$("#notice").removeClass("alert alert-success")
			$("#notice").addClass("alert alert-warning")
			$("#notice").text("Please enter order restaurant");
		}
		else if(invitedFriend.length==0 || invitedGroups.length==0)	{
			$("#notice").removeClass("alert alert-success")
			$("#notice").addClass("alert alert-warning")
			$("#notice").text("You Havent invited any of your friends yet")
		}
		else
		{
			$.ajax({
				method:"post",
				url:"/orders",
				data:{order:{mtype:mtype, restaurant: restaurant}},
				success:function(res){
					$("#orderId").val(res.id);
					invitedFriend=[]
					invitedGroups=[]	
				}
			})
		}
	});

	//= invite friend to oreder click function
	$("#fadd").click(function(e){
		e.preventDefault();
		searchTxt = $('#fsearch').val()
		var flag=0
		
		$.each($("#myfriends").children(),function(ind,elem){
			fname = $(elem).val()
			fid = $(elem).attr("data-id")
			favatar = $(elem).attr("data-avatar")
			if(searchTxt==fname && !invitedFriend.includes(fid))
			{
				flag=1

				$.ajax({
					method:"post",
					url:"/orders/invite",
					data:{user_id:fid},
					success:function(res){
						$("#notice").text(res.message);
						if(res.error){
							$("#notice").removeClass("alert alert-success")
							$("#notice").addClass("alert alert-danger")
						}
						else
						{
							$("#notice").removeClass("alert alert-danger")
							$("#notice").addClass("alert alert-success");
							invitedFriend.push(res.id);
							htmlTxt = "<span id="+res.id+">"+res.name+"<br />"
							htmlTxt +="<img src="+res.avatar+ "><a onclick='deletef("+res.id+")'>Remove"
							htmlTxt += "</a></span>"
							$('#invitedFriend').parents("").append(htmlTxt);
						}
					}
				});
			}
			else if(searchTxt==fname && invitedFriend.includes(fid))
			{
				$("#notice").removeClass("alert-danger  alert-success");
				$("#notice").addClass("alert-warning");
				$("#notice").text("Kindly note that you can't add the same user twice");
			}
		})
		if(flag==0)
		{
			$("#notice").removeClass("alert-warning  alert-success");
			$("#notice").addClass("alert-danger");
			$("#notice").text("Kindly note that there is no friends of you with this name");
		}
	})

	//= invite group to oreder click function
	$('#gadd').click(function(e){
		e.preventDefault();
		searchTxt = $('#gsearch').val()
		var flag=0
		$("#notice").html("");
		$("#notice").removeClass("alert-danger alert-success");

		$.each($("#mygroups").children(),function(ind,elem){
			gname = $(elem).val()
			gid = $(elem).attr("data-id")
			if(searchTxt==gname && !invitedGroups.includes(gid))
			{
				flag=1
				$.ajax({
					method:"post",
					url:"/orders/invite",
					data:{group_id:gid},
					success:function(res){
						$.each(res,function(i,e){
							msg = "";
							if(e.error){
								msg = "<p class='alert alert-danger'>"+e.message+"</p>";
							}
							else
							{
								msg = "<p class='alert alert-success'>"+e.message+"</p>";
								invitedGroups.push(gid);
								htmlTxt = "<span id="+e.id+">"+e.name+"<br />"
								htmlTxt +="<img src="+e.avatar+ "><a onclick='deletef("+e.id+")'>Remove"
								htmlTxt += "</a></span>"
								$('#invitedFriend').append(htmlTxt);
							}
							$("#notice").append(msg);
						})
					}
				});
			}
			else if(searchTxt==gname && invitedGroups.includes(gid))
			{
				$("#notice").removeClass("alert-danger  alert-success");
				$("#notice").addClass("alert-warning");
				$("#notice").text("Kindly note that you can't add the same group twice");
			}
		})
		if(flag==0)
		{
			$("#notice").removeClass("alert-warning  alert-success");
			$("#notice").addClass("alert-danger");
			$("#notice").text("Kindly note that there is no group of you with this name");
		}

	})

	//= un invite friend to oreder click function
	$(".uninvite").click(function(e){
		e.preventDefault();
		row = $(this).parents("tr");
		id= $(this).attr("data");
		$.ajax({
			method:"post",
			url:"/invitations/"+id,
			data:{_method:"delete"},
			success:function(res){
				$("#notice").text(res.message);
				if(res.error){
					$("#notice").removeClass("alert alert-success");
					$("#notice").addClass("alert alert-danger");
				}
				else
				{
					$("#notice").removeClass("alert alert-danger");
					$("#notice").addClass("alert alert-success");
				}
				row.remove();
			}
		})

	})

})
	function remFriend(e){
		$.ajax({
			url:"/groups/removeFromGroup",
			method:"post",
			data:{gid: $(e).attr('group_id'), uid: $(e).attr('user_id')},

			success: function(res){
				$("#notice").text(res.message);
				if(res.error){
					$("#notice").removeClass("alert alert-success")
					$("#notice").addClass("alert alert-danger")
				}else{
					$("#notice").removeClass("alert alert-danger")
					$("#notice").addClass("alert alert-success")
			   	    $( "div" ).remove("#"+res.userfriend.id)
			   	}
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