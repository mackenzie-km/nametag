$(document).ready(function() {
  attachInfoListeners();
  attachLookupListeners();
});

function attachInfoListeners(){
  $('.more-button').on("click", function(event) {
    event.preventDefault();
     let id = $(this).data("id");
      $.get("/contacts/" + id + ".json", function(data) {
        let info = "<b>More Contact Information</b><br>" + organizeInfo(data)
        $('#more-div').html(info)
      });
    });
};

function attachLookupListeners(){
  $('.lookup-button').on("click", function(event) {
    event.preventDefault();
    if (!!$('#event_contacts_name').val()) {
      $.get("/contacts/" + grabId() + ".json", function(data) {
        let info = "<b>More Contact Information</b><br>" + organizeInfo(data)
        $('#more-div').html(info)
        });
    };
  });
}

function humanDate(data){
  let dateArray = data.split("T")
  return dateArray[0]
};

function organizeInfo(data) {
  if (data["id"]) {
    let array = Object.entries(data).map(function(element) {
      if ((element[0] === "created_at") || (element[0] === "updated_at")) {
        return "<b>" + element[0] + ":</b> " + humanDate(element[1]) + "<br>";
      } else if ((element[0] === "events") && (typeof element[1][0] === 'object'))  {
        return returnEvents(element)
      } else if (element[1] && (typeof element[1] === 'object'))  {
        return "<b>" + element[0] + ":</b> " + Object.values(element[1]) + "<br>"
      } else {
        return "<b>" + element[0] + ":</b> " + (element[1] || "N/A") + "<br>";
      };
    })
    return array.join("");
  } else {
    return "This contact hasn't been created yet. Use the add button to create a new contact."
  }
};

// make sure events is always working

function returnEvents(element){
  if (element[1][1] != "") {
    debugger
    return "<b>" + "last event attended:</b> " + Object.values(element[1][0])[1] + " " + Object.values(element[1][0])[2] + "<br>"
  } else {
    return "<b>" + "last event attended:</b> N/A <br>"
  }

}

function grabId() {
  let box = $('#event_contacts_name').val()
  let id = $('#contacts_autocomplete option').filter(function() {
      return this.value == box;
  }).data('id');
  return id
}

function lookupInBox() {
  debugger
  $.get("/contacts/" + grabId() + ".json", function(data) {
    let info = "<b>More Contact Information</b><br>" + organizeInfo(data)
    $('#more-div').html(info)
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
