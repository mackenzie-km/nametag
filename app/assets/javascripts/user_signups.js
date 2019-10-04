$(document).ready(function() {
  attachSubmitListener();
});

function attachSubmitListener(){
 $('#submit').on("click", function(event) {
   event.preventDefault();
   let data = $('form').serialize();
   $.ajax({
       type: "POST",
       url: window.location.pathname+window.location.search,
       dataType: "json",
       data: data,
       success: function(){
         alert("Thanks! We've received your response.")
         location.reload();
       },
       error: function(){
         alert("Please try again, checking that you have included your name.")
         location.reload();
       }
     });
 });
}
