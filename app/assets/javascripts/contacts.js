
$(document).ready(function() {
  attachSubmitListeners();
});

class Contact {
 constructor(data) {
    this.id = data["id"];
    this.name = data["name"]
    this.email = data["email"];
    this.major = data["major"];
    this.staff = data["user"]["email"];
    this.events = data["events"];
    this.timestamp = data["created_at"];
  };
};


// allows for contact.cleanTimestamp() method to standardize dates via the prototype

Contact.prototype.cleanTimestamp = function() {
  let dateArray = this.timestamp.split("T");
  return dateArray[0];
};


function attachSubmitListeners(){
//  $('input[id=submit]').on("click", function(event) {
 $('a.btn').on("click", function(event) {
   event.preventDefault();
 });
}
