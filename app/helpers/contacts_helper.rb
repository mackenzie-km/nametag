module ContactsHelper
  def birthday_human(contact)
    if contact.birthday
      contact.birthday.strftime("%B %-d")
    else
      nil
    end
  end

  def button_text(params)
    ("Create Contact For Event" if !!params[:event_id]) || "Create Contact"
  end

  def button_link(params)
    ("/events/#{params[:event_id]}/contacts/new" if !!params[:event_id]) || new_contact_path
  end
end
