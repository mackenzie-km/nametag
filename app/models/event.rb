class Event < ApplicationRecord
  has_many :contacts_events
  has_many :contacts, through: :contacts_events
end
