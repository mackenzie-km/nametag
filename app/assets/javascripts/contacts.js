
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
    this.email = data["email"] || "N/A";
    this.staff_name = data["user"]["email"].split("@", 1)[0] || "N/A";
    this.gender = data["gender"] || "N/A";
  };
};


// allows for contact.cleanTimestamp() method to standardize dates via the prototype

function attachNameListener(){
 $('a#name').on("click", function(event) {
   event.preventDefault();
   if (!!$('input#contact_name').val()) {
     let criteria = $('input#contact_name').serialize()
     getJSONRobot(criteria)
  }
 });
}

function attachStaffListener(){
 $('a#staff').on("click", function(event) {
   event.preventDefault();
   if (!!$('input#contact_email').val()) {
     let criteria = $('input#contact_email').serialize()
     getJSONRobot(criteria)
    }
  });
}

function attachUnclaimedListener(){
 $('a#unclaimed').on("click", function(event) {
   event.preventDefault();
   let criteria = {"unclaimed": "true"}
   getJSONRobot(criteria)
  });
}

function attachAllListener(){
 $('a#all').on("click", function(event) {
   event.preventDefault();
   let criteria = {"all": "true"}
   getJSONRobot(criteria)
 });
}

function attachRecentlyUpdatedListener(){
 $('a#recently_updated').on("click", function(event) {
   event.preventDefault();
   let criteria = {"recently_updated": "true"}
   getJSONRobot(criteria)
});
}

function getJSONRobot(criteria){
  $('tbody').empty();
  $.getJSON("/contacts.json", criteria, function(data) {
    if (!(typeof data === Array)) { data = [].concat(data) }
    data.map(function(object){
     let contact = new Contact(object)
     let html = tableHtmlPrinter(contact)
     $('tbody').append(html)
    });
  });
}

function tableHtmlPrinter(contact){
  return `<tr>
    <td>${contact.name}</td>
    <td>
      <a href="/contacts/${contact.id}/edit">
        <i class="material-icons">edit</i>
      </a>
      <a href="/contacts/${contact.id}">
        <i class="material-icons">zoom_in</i>
      </a>
    </td>
    <td>${contact.staff_name}</td>
    <td>${contact.email}</td>
    <td>${contact.gender}</td>
  </tr>`
}
