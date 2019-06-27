class Contact < ApplicationRecord
  belongs_to :user
  has_many :contacts_events
  has_many :events, through: :contacts_events

  def birthday_human
    self.birthday.strftime("%B %-d")
  end
end
