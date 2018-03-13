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
				$("#grp").prevAll("legend").text(res.name);
				$.each(res.users, function( index, user ) {
					console.log(user)
					htmlTxt = "<div class='col-3-'><img src="+user.avatar_url+">"
					htmlTxt +="<h3>"+user.name+"</h3>"
        			htmlTxt += "<a data-confirm='Are you sure?' rel='nofollow' data-method='delete' href='/friendships/"+user.id+"'>Remove</a>"
        			htmlTxt += "</div>"
        			$("#grp").html($("#grp").html()+htmlTxt)

				})

			}
		});

	})
	$("#friends").on("click","p",function(e){
		console.log(e.target)
	})
	$("#delFriend").click(function(e){
		e.preventDefault();

	})


})

