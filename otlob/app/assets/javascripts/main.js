$(function(){
	//= Submit the form of find friend action
	
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
					htmlTxt += "<button onClick='remFriend(this)' data-confirm='Remove "+user.name+" from "+res.name+" group ?' "
					htmlTxt += "group_id='"+res.id+"' user_id='"+user.id+"'>"
        			htmlTxt += "Remove</button></div>"
        			$("#grp").html($("#grp").html()+htmlTxt)
				})

			}
		});

	})

	$("#friends").on("click","p",function(e){
		console.log(e.target)
	})
	$("#delFriend").click(function(e){ })


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
	

