module ContactsHelper
  def birthday_human(contact)
    if contact.birthday
      contact.birthday.strftime("%B %-d")
    else
      nil
    end
  end

  def c_button_text(params)
    ("Create Contact For Event" if !!params[:event_id]) || "Create Contact"
  end

  def c_button_link(params)
    ("/events/#{params[:event_id]}/contacts/new" if !!params[:event_id]) || new_contact_path
  end

  def index_header(params)
    if params[:event_id]
      "View Contacts for Event #{params[:event_id]}"
    elsif params[:display_all]
      "View All Contacts"
    else
      "View My Contacts"
    end
  end
end
