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

	$("#delFriend").click(function(e){
		e.preventDefault();

	})
})