module ContactsHelper

  # to display birthday in human readable format
  def birthday_human(contact)
    if contact.birthday
      contact.birthday.strftime("%B %-d")
    else
      nil
    end
  end

  # change button text depending on whether creating nested contact or normal contact
  def c_button_text(params)
    ("Create Contact For Event" if !!params[:event_id]) || "Create Contact"
  end

# change button link depending on whether creating nested contact or normal contact
  def c_button_link(params)
    ("/events/#{params[:event_id]}/contacts/new" if !!params[:event_id]) || new_contact_path
  end

# change header depending on which data set of contacts is selected
  def c_index_header(params)
    if params[:event_id]
      "View Contacts for Event #{params[:event_id]}"
    elsif params[:display_all]
      "View All Contacts"
    else
      "View My Contacts"
    end
  end
end
