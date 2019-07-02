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
end
