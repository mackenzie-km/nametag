
$(document).ready(function() {
  attachNameListener();
  attachStaffListener();
  attachUnclaimedListener();
  attachAllListener();
  attachRecentlyUpdatedListener();
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


function attachNameListener(){
 $('a#name').on("click", function(event) {
   event.preventDefault();
   if (!!$('input#contact_name').val()) {
     let criteria = $('input#contact_name').serialize()
     $.getJSON("/contacts.json", criteria, function(data) {
       debugger
      }
    );
  }
 });
}

function attachStaffListener(){
 $('a#staff').on("click", function(event) {
   event.preventDefault();
   if (!!$('input#contact_email').val()) {
     let criteria = $('input#contact_email').serialize()
     $.getJSON("/contacts.json", criteria, function(data) {
       debugger
      }
    );
  }
 });
}

function attachUnclaimedListener(){
 $('a#unclaimed').on("click", function(event) {
   event.preventDefault();
   let criteria = {"unclaimed": "true"}
    $.getJSON("/contacts.json", criteria, function(data) {
       debugger
    });
 });
}

function attachAllListener(){
 $('a#all').on("click", function(event) {
   event.preventDefault();
   let criteria = {"all": "true"}
    $.getJSON("/contacts.json", criteria, function(data) {
       debugger
    });
 });
}

function attachRecentlyUpdatedListener(){
 $('a#recently_updated').on("click", function(event) {
   event.preventDefault();
   let criteria = {"recently_updated": "true"}
    $.getJSON("/contacts.json", criteria, function(data) {
       debugger
    });
 });
}
