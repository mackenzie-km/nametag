$(document).ready(function() {
  attachInfoListeners();
  attachLookupListeners();
  attachAddListeners();
  attachRemoveListeners();
  attachSubmitListeners();
});

// create shadow class to help work with data

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
  lastAttended() {
    if (this.events.length > 0) {
    return this.events[0]["name"] + " on " + this.events[0]["date"];
    } else {
      return "N/A"
    }
  };
};

// allows for contact.cleanTimestamp() method to standardize dates via the prototype

Contact.prototype.cleanTimestamp = function() {
  let dateArray = this.timestamp.split("T");
  return dateArray[0];
};


// helpers to grab contact information from input box

function grabId() {
  let box = $('#event_contacts_name').val();
  let id = $('#contacts_autocomplete option').filter(function() {
      return this.value == box;
  }).data('id');
  return id;
}

function lookupInBox() {
  $.get("/contacts/" + grabId() + ".json", function(data) {
    $('#more-div').html(printInfo(contact));
  });
}

// functions for returning html and css

function printInfo(contact) {
  let info;
  if (!!contact.id) {
    info =
    `<label class="lb-lg">More contact info</label><br>
    <b>Name:</b> ${contact.name}<br>
    <b>Id:</b> ${contact.id}<br>
    <b>Email:</b> ${contact.email}<br>
    <b>Last Attended:</b> ${contact.lastAttended()}<br>
    <b>Created On:</b> ${contact.cleanTimestamp()}<br>
    <b>Staff:</b> ${contact.staff} `
  } else {
    info = "This contact hasn't been created yet. Use the add button to create a new contact.";
  }
  return info
}

function infoButton(contact_name, contact_id, event_id){
  return `<div id="small_button_${contact_id}" class="btn btn-primary btn-sm">${contact_name}
  <a href="#" class="more-button" data-id="${contact_id}">
  <i class="material-icons inverse">info</i></a>
  <a href="#" class="remove-button" data-contact-id="${contact_id}" data-event-id="${event_id}">
  <i class="material-icons inverse">remove_circle</i></a> </div>`
}

// Attach Listeners Functions

function attachInfoListeners(){
  $('.more-button').on("click", function(event) {
    event.preventDefault();
     let id = $(this).data("id");
      $.get("/contacts/" + id + ".json", function(data) {
        let contact = new Contact(data);
        $('#more-div').html(printInfo(contact));
      });
    });
}

function attachLookupListeners(){
  $('.lookup-button').on("click", function(event) {
    event.preventDefault();
    if (!!$('#event_contacts_name').val()) {
      $.get("/contacts/" + grabId() + ".json", function(data) {
        let contact = new Contact(data);
        $('#more-div').html(printInfo(contact));
        });
    }
  });
}

function attachAddListeners(){
  $('.add-button').on("click", function(event) {
    event.preventDefault();
    let contact_id = grabId();
    if (!!$('#event_contacts_name').val() && !$('#small_button_' + contact_id).length) {
      let event_id = $(this).data("id")
      let url = "/events/" + event_id
      let data = $('form.add-attendees').serializeArray();
      data.push({name: "event[contacts][id]", value: grabId()});
      $.ajax({
          type: "PATCH",
          url: url,
          dataType: "json",
          data: data
        });
      $('#attendees').prepend(infoButton(data[3]["value"], contact_id, event_id))
      $(document).ready(function() {
        attachInfoListeners();
        attachRemoveListeners();
      });
    }
    $('#event_contacts_name').val("")
  });
}

function attachRemoveListeners(){
    $('.remove-button').on("click", function(event) {
      event.preventDefault();
      let url = "/events/" + $(this).data('event-id');
      let contact = $(this).data('contact-id');
      let data = $('form.add-attendees').serializeArray();
        data.push({name: "event[contacts][id]", value: contact});
        $.ajax({
            type: "PATCH",
            url: url,
            dataType: "json",
            data: data
          });
      $('#small_button_' + String(contact)).remove();
      });

}

function attachSubmitListeners(){
  $('input[value=Submit]').on("click", function(event) {
    event.preventDefault();
    data = $('form.main-details').serializeArray();
      $.ajax({
          type: "POST",
          url: "/events",
          dataType: "json",
          data: data
        });
    });
}
