class Event < ApplicationRecord
  has_many :contacts_events
  has_many :contacts, through: :contacts_events
  validates :name, presence: true
  validates :date, presence: true

  scope :access, -> (admin_level) { where('admin_level <= ?', admin_level) }

  def date_human
    self.date.strftime("%B %-d, %Y")
  end

  def contacts_count
    self.contacts.count
  end

  def guests_count
    self.contacts_events.sum(:guests)
  end

  def update_guests(event_params, event)
    event_params[:guests].each do |key, value|
      if value != "0"
        ContactsEvent.where(contact_id: key.to_i, event_id: event.id).update_all(guests: value.to_i)
      end
    end
  end

  def self.collect_date(event_params)
    Date.new event_params["date(1i)"].to_i, event_params["date(2i)"].to_i, event_params["date(3i)"].to_i.to_i
  end

end
