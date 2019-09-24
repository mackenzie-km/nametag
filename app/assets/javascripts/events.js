$(document).ready(function() {
  attachInfoListeners();
  attachLookupListeners();
  attachAddListeners();
  attachRemoveListeners();
});

function attachInfoListeners(){
  $('.more-button').on("click", function(event) {
    event.preventDefault();
     let id = $(this).data("id");
      $.get("/contacts/" + id + ".json", function(data) {
        let info = '<label class="lb-lg">More Contact Info:</label><br>' + organizeInfo(data);
        $('#more-div').html(info);
      });
    });
}

function attachLookupListeners(){
  $('.lookup-button').on("click", function(event) {
    event.preventDefault();
    if (!!$('#event_contacts_name').val()) {
      $.get("/contacts/" + grabId() + ".json", function(data) {
        let info = '<label class="lb-lg">More Contact Info</label><br>' + organizeInfo(data);
        $('#more-div').html(info);
        });
    }
  });
}

function attachAddListeners(){
  $('.add-button').on("click", function(event) {
    event.preventDefault();
    if (!!$('#event_contacts_name').val()) {
      let url = "/events/" + $(this).data("id")
      let data = $('form.add-attendees').serializeArray();
      data.push({name: "event[contacts][id]", value: grabId()});
      $.ajax({
          type: "PATCH",
          url: url,
          dataType: "json",
          data: data
        });
      $('#attendees').prepend(infoButton(data[3]["value"], data[4]["value"]))
      $(document).ready(function() {
        attachInfoListeners();
      });
    }
  });
}

function attachRemoveListeners(){
  $('.remove-button').on("click", function(event) {
    event.preventDefault();
      let url = "/events/" + $(this).data("id")
      let data = $('form.add-attendees').serializeArray();
      data.push({name: "event[contacts][id]", value: grabId()});
      $.ajax({
          type: "PATCH",
          url: url,
          dataType: "json",
          data: data
        });
    });
}

function humanDate(data){
  let dateArray = data.split("T");
  return dateArray[0];
}

function organizeInfo(data) {
  if (data["id"]) {
    let array = Object.entries(data).map(function(element) {
      if ((element[0] === "created_at") || (element[0] === "updated_at")) {
        return returnDates(element);
      } else if ((element[0] === "events"))  {
        return returnEvents(element);
      } else if (element[1] && (typeof element[1] === 'object'))  {
        return returnObjects(element);
      } else {
        return returnRegular(element);
      }
    });
    return array.join("");
  } else {
    return "This contact hasn't been created yet. Use the add button to create a new contact.";
  }
}

function infoButton(name, id){
  return `<button class="btn btn-primary btn-sm">${name}
  <a href="#" class="more-button" data-id="${id}"><i class="material-icons inverse">info</i></a>
  <a href="#" class="remove-button" data-id="${id}"><i class="material-icons inverse">remove_circle</i></a>
  </button>`
}

function returnDates(element){
  return "<b>" + element[0] + ":</b> " + humanDate(element[1]) + "<br>";
}

function returnObjects(element){
  return "<b>" + element[0] + ":</b> " + Object.values(element[1]) + "<br>";
}

function returnRegular(element){
  return "<b>" + element[0] + ":</b> " + (element[1] || "N/A") + "<br>";
}

function returnEvents(element){
  if (!!element[1][0]) {
    return "<b>" + "last event attended:</b> " + Object.values(element[1][0])[1] + " " + Object.values(element[1][0])[2] + "<br>";
  } else {
    return "<b>" + "last event attended:</b> N/A <br>";
  }

}

function grabId() {
  let box = $('#event_contacts_name').val();
  let id = $('#contacts_autocomplete option').filter(function() {
      return this.value == box;
  }).data('id');
  return id;
}

function lookupInBox() {
  $.get("/contacts/" + grabId() + ".json", function(data) {
    let info = '<label class="lb-lg">More Contact Info</label><br>' + organizeInfo(data);
    $('#more-div').html(info);
  });
}

// function Contact(data) {
//   this.name = data["name"];
//   this.email = data["email"];
//   this.gender = data["gender"];
//   this.staff = data["user"]["name"];
//   this.created = humanDate(data["created_at"])
// }

// Contact.prototype.humanDate = humanDate(data);
// Event.prototype.humanDate = humanDate(data);
