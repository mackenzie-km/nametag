class Event < ApplicationRecord
  has_many :contacts_events
  has_many :contacts, through: :contacts_events

  def date_human
    self.date.strftime("%B/%-d/%Y")
  end
end
