$(document).ready(function() {
  attachListeners();
});

function attachListeners(){
  $('.more-button').on("click", function(event) {
    event.preventDefault();
      let id = $(this).data("id");
       $.get("/contacts/" + id + ".json", function(data) {
         let info = "<b>More Contact Information</b><br>" + organizeInfo(data)
         $('#more-div').html(info)
       });
    });
};

function humanDate(data){
  let dateArray = data.split("T")
  return dateArray[0]
};

function organizeInfo(data) {
  debugger
  if (data["id"]) {
    let array = Object.entries(data).map(function(element) {
      if ((element[0] === "created_at") || (element[0] === "updated_at")) {
        return "<b>" + element[0] + ":</b> " + humanDate(element[1]) + "<br>";
      } else {
        return "<b>" + element[0] + ":</b> " + element[1] + "<br>";
      };
    })
    return array.join("");
  } else {
    return "This contact hasn't been created yet. Use the add button to create a new contact."
  }
};

// function Contact(data) {
//   this.name = data["name"];
//   this.email = data["email"];
//   this.gender = data["gender"];
//   this.staff = data["user"]["name"];
//   this.created = humanDate(data["created_at"])
// }

// Contact.prototype.humanDate = humanDate(data);
// Event.prototype.humanDate = humanDate(data);
