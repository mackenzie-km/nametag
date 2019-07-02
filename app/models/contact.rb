class Contact < ApplicationRecord
  belongs_to :user
  has_many :contacts_events
  has_many :events, through: :contacts_events

  def birthday_human
    if self.birthday
      self.birthday.strftime("%B %-d")
    else
      nil
    end
  end

  def self.add_contacts(params, event)
    params.reject!(&:empty?)
    params.collect do |contact_id|
      contact = Contact.find_or_create_by(id: contact_id)
      contact.events << event
      contact
    end
  end
end
