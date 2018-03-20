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
		mtype = $("input[name='order[mtype]']:checked").val();
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
		else if(invitedFriend.length==0 && invitedGroups.length==0)	{
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
							htmlTxt = "<div class='col-sm-3 text-center' style='display:inline' id='"+e.id+"'>"
							htmlTxt +="<img src='"+res.avatar+ "' height='100' width='100'><br/>"
							htmlTxt += "<strong>"+res.name+"</strong><br/>"
							htmlTxt += "<a onclick='deletef("+res.id+")'>Remove</a></div>"
							$('#invitedFriend').append(htmlTxt);
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
	// add item to order
	$("#submit").click (function()
	{
		Item= $("#item").val()
		Amount= $("#amount").val()
		Price= $("#price").val()
		Comment= $("#comment").val()
		User= $("#user").val()
		Order=$("#order").val()
		console.log($("#item").empty())
		if ($.isEmptyObject(Item)||$.isEmptyObject(Price))
		{
			alert("The item, price and amount can't be left blank")
		}else
		{
			console.log("intered")
			$.ajax({
		       url: '/createitem',
		       method:"post",
		       data: {item:Item,price:Price,comment:Comment,user:User,order:Order,amount:Amount},
		       success: function(res) {
		        alert("Enter")
		       },
		       errors:function(error)
		       {
		       		alert("error")
		       }
		     });
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
								htmlTxt = "<div class='col-sm-3 text-center' style='display:inline' id='"+e.id+"'>"
								htmlTxt +="<img src='"+e.avatar+ "' height='100' width='100'><br/>"
								htmlTxt += "<strong>"+e.name+"</strong><br/>"
								htmlTxt += "<a onclick='deletef("+e.id+")'>Remove</a></div>"
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
	// $(".uninvite").click(function(e){
	// 	e.preventDefault();
	// 	row = $(this).parents("tr");
	// 	id= $(this).attr("data");
	// 	$.ajax({
	// 		method:"post",
	// 		url:"/invitations/"+id,
	// 		data:{_method:"delete"},
	// 		success:function(res){
	// 			$("#notice").text(res.message);
	// 			if(res.error){
	// 				$("#notice").removeClass("alert alert-success");
	// 				$("#notice").addClass("alert alert-danger");
	// 			}
	// 			else
	// 			{
	// 				$("#notice").removeClass("alert alert-danger");
	// 				$("#notice").addClass("alert alert-success");
	// 			}
	// 			row.remove();
	// 		}
	// 	})

	// })

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


	function remove(array, element) {
	    const index = array.indexOf(element);
	    array.splice(index, 1);
	}

	function deletef(id)
	{
		remove(invitedFriend,id)
		$.ajax({
			method:"post",
			url:"/orders/uninvite",
			data:{uId: id},
			success:function(res){
				$("#notice").text(res.message);
				if(res.error){
					$("#notice").removeClass("alert alert-success")
					$("#notice").addClass("alert alert-danger")
				}else{
					$("#notice").removeClass("alert alert-danger")
					$("#notice").addClass("alert alert-success")
			   	    $("#"+id).remove();
			   	}
			}
		})
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
