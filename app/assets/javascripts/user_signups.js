$(document).ready(function() {
  attachSubmitListener();
});

function attachSubmitListener(){
 $('#submit').on("click", function(event) {
   event.preventDefault();
   debugger
 });
}
