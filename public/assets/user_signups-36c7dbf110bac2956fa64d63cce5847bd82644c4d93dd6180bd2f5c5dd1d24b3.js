function attachSubmitListener(){$("#submit").on("click",function(e){e.preventDefault();let a=$("form").serialize();$.ajax({type:"POST",url:window.location.pathname+window.location.search,dataType:"json",data:a,success:function(){alert("Thanks! We've received your response."),location.reload()},error:function(){alert("Please try again, checking that you have included your name."),location.reload()}})})}$(document).ready(function(){attachSubmitListener()});