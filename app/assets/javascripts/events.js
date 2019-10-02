// need to figure out why flash message doesn't work
// need to get the add_button id issue fixed

$(document).ready(function() {
  attachSubmitListeners();
  attachInfoListeners();
  attachLookupListeners();
  attachAddListeners();
  attachRemoveListeners();
  hideAttendees();
});

// hides attendees section if event hasn't been made yet
function hideAttendees(){
  if (!$('input[id=submit]').data('id')) {
    $('#attendees-section').hide();
  };
}

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

class Event {
 constructor(data) {
    this.id = data["id"];
    this.name = data["name"]
    this.date = data["date"];
    this.timestamp = data["created_at"];
    this.contacts = data["contacts"];
    this.staff_count = data["staff_count"];
    this.guest_count = data["guest_count"];
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
    `<label>Name:</label> ${contact.name}<br>
    <label>Email:</label> ${contact.email}<br>
    <label>Last Attended:</label> ${contact.lastAttended()}<br>
    <label>Created On:</label> ${contact.cleanTimestamp()}<br>
    <label>Staff:</label> ${contact.staff} `
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
      let url = window.location.pathname
      url = url.substring(0, url.length - 5);
      let data = $('form.add-attendees').serializeArray();
      let authenticity_token = $('meta[name="csrf-token"]').attr('content')
      data.forEach(function(item, i) { if (item.name == "authenticity_token") item.value = authenticity_token; });
      data.push({name: "event[contacts][id]", value: grabId()});
      data.push({name: "_method", value: "patch"});
      let name = findName(data)
      $.ajax({
          type: "PATCH",
          url: url,
          dataType: "json",
          data: data,
          beforeSend: function(request) {
    request.setRequestHeader("authenticity_token", data[1]);
  }
        }).done(function(data) {
            $('#attendees').prepend(infoButton(name, contact_id, event_id))
            attachInfoListeners();
            attachRemoveListeners();
            $('#event_contacts_name').val("")
        });
    }

  });
}

function findName(data) {
  let found = data.find(function(element) {
    return element.name == "event[contacts][name]";
  });
  return found.value
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
   $('input[id=submit]').on("click", function(event) {
    event.preventDefault();
    let id = $(this).data('id')
    let data = $('form.main-details').serializeArray();
    if (!id) {
       $.ajax({
           type: "POST",
           url: "/events",
           dataType: "json",
           data: data
         }).done(function(data) {
           if (!!data) {
             window.history.pushState(data, "", `/events/${data["id"]}/edit`);
             let event = new Event(data);
             $('#info-container').hide()
             $('#attendees-section').show()
             $('#form-wrapper').html(eventCardWrapper(event));
           } else {
             alert('Please make sure the name field is filled out and try again');
           }
        });
     } else {
         $.ajax({
             type: "PATCH",
             url: "/events/" + id,
             dataType: "json",
             data: data
           }).done(function(data) {
         if (!!data["name"]) {
           window.history.pushState(data, "", `/events/${data["id"]}/edit`);
           let event = new Event(data);
           $('#info-container').hide()
           $('#attendees-section').show()
           $('#form-wrapper').html(eventCardWrapper(event));
         } else {
           alert('Please make sure the name field is filled out and try again');
         }
      });
     }
  });
 }

// need to figure out why it's not serializing that
// and also prettify (block buttons, fix text, standardize size)
// and when you hit edit -> reload

 function eventCardWrapper(event){
   return `<div class="row justify-content-center center-this-div">
     <div class="col-lg-5 justify-content-center">
         <div class="card card-stats">
           <div class="card-header card-header-icon">
             <div class="card-icon">
               <i class="material-icons">info</i>
             </div>
           <h3 class="card-title">Event Info</h3>
           <p class="card-category">
           <label>Event date:</label> ${event.date}<br>
           <label>Event name:</label> ${event.name}<br>
           <label>Staff Count:</label> ${event.staff_count}<br>
           <label>Guest Count:</label> ${event.guest_count}<br>
           </p>
        </div>
      </div>
    </div>
  <div class="col-lg-5 justify-content-center">
      <div class="card card-stats">
        <div class="card-header card-header-icon">
          <div class="card-icon">
            <i class="material-icons">zoom_in</i>
          </div>
        <h3 class="card-title">Contact Info</h3>
        <p class="card-category" id="more-div">
          Drill down by selecting any info icon on the page
        </div>
      </p>
     </div>
   </div>
 <div class="col-lg-2 text-center">
    <a href="/events" class="btn btn-primary btn-block">  All  Events  <i class="material-icons">event</i></a>
    <a href="/events/${event.id}/" class="btn btn-primary btn-block">  View  Event  <i class="material-icons">zoom_in</i></a>
    <a href="/events/${event.id}/edit" class="btn btn-primary btn-block">Modify Info <i class="material-icons">edit</i></a>
 </div>
  </div>
 </div>
   </div>`
 }
