$(document).ready(function() {
  attachListeners();
});

function attachListeners(){
  $('.more-button').on("click", function(event) {
    event.preventDefault();
      let id = $(this).data("id");
       $.get("/contacts/" + id + ".json", function(data) {
         $('#more-div').text(data)
       });
    });
};

// YAY, an object is showing up! need to parse the object now

function humanDate(data){
  let dateArray = data["date"].slice(0, -1)
  return dateArray[0]
};

// Contact.prototype.humanDate = humanDate(data);
// Event.prototype.humanDate = humanDate(data);
