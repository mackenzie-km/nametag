$(document).ready(function() {
  attachInfoListeners();
  attachLookupListeners();
  attachAddListeners();
  attachRemoveListeners();
});

// create shadow class to help work with data

class Contact {
 constructor(data) {
  this.id = data["id"];
  this.name = data["name"]
  this.email = data["email"];
  this.major = data["major"];
  this.events = data["events"];
  this.first_event = data["events"][0];
}
};


// helpers to grab contact information from input

function grabId() {
  let box = $('#event_contacts_name').val();
  let id = $('#contacts_autocomplete option').filter(function() {
      return this.value == box;
  }).data('id');
  return id;
}

function lookupInBox() {
  $.get("/contacts/" + grabId() + ".json", function(data) {
    let info = '<label class="lb-lg">More contact info</label><br>' + organizeInfo(data);
    $('#more-div').html(info);
  });
}

// functions for returning html and css

function organizeInfo(data) {
  debugger
  if (!!data["id"]) {
    let contact = new Contact(data)
    for (let [key, value] of Object.entries(contact)) {
      return `<b>${key}</b>: ${value}<br>`
    }
    // let array = Object.entries(data).map(function(element) {
    //   if ((element[0] === "created_at") || (element[0] === "updated_at")) {
    //     return returnDates(element);
    //   } else if ((element[0] === "events"))  {
    //     return returnEvents(element);
    //   } else if (element[1] && (typeof element[1] === 'object'))  {
    //     return returnObjects(element);
    //   } else {
    //     return returnRegular(element);
    //   }
    // });
    // return array.join("");
  } else {
    return "This contact hasn't been created yet. Use the add button to create a new contact.";
  }
}

function infoButton(name, contact_id, event_id){
  return `<div id="small_button_${contact_id}" class="btn btn-primary btn-sm">${name}
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
        let info = '<label class="lb-lg">More contact info:</label><br>' + organizeInfo(data);
        $('#more-div').html(info);
      });
    });
}

function attachLookupListeners(){
  $('.lookup-button').on("click", function(event) {
    event.preventDefault();
    if (!!$('#event_contacts_name').val()) {
      $.get("/contacts/" + grabId() + ".json", function(data) {
        let info = '<label class="lb-lg">More contact info</label><br>' + organizeInfo(data);
        $('#more-div').html(info);
        });
    }
  });
}

function attachAddListeners(){
  $('.add-button').on("click", function(event) {
    event.preventDefault();
    let contact = grabId();
    if (!!$('#event_contacts_name').val() && !$('#small_button_' + contact).length) {
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
      $('#attendees').prepend(infoButton(data[3]["value"], contact, event_id))
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
