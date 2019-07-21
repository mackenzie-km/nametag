module ContactsHelper
  def birthday_human(contact)
    if contact.birthday
      contact.birthday.strftime("%B %-d")
    else
      nil
    end
  end
end
