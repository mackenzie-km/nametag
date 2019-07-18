class ContactsEvent < ApplicationRecord
  belongs_to :contact
  belongs_to :event

  def guests=(value)
    self[:guests] = value
    self.save
  end

  def guests
    self[:guests]
  end

end
