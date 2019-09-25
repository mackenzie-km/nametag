class Event < ApplicationRecord
  has_many :contacts_events
  has_many :contacts, through: :contacts_events
  validates :name, presence: true
  validates :date, presence: true
  validates_numericality_of :staff_count, :only_integer => true
  validates_numericality_of :guest_count, :only_integer => true

  scope :access, -> (admin_level) { where('admin_level <= ?', admin_level) }

  def self.toggle_contact(params)
    if !!params[:event][:contacts]
      hash = {contact_id: params[:event][:contacts][:id], event_id: params[:id]}
      contact_event = ContactsEvent.find_by(hash)
      if !!contact_event then ContactsEvent.where(hash).each {|x| x.destroy } else ContactsEvent.create(hash) end
    end
  end

  def contacts_count
    self.contacts.count
  end

# to collect dates - bootstrap form params are not as clean as before
  def self.collect_date(event_params)
    Date.new event_params["date(1i)"].to_i, event_params["date(2i)"].to_i, event_params["date(3i)"].to_i
  end

  def admin_level=(admin_level)
    self[:admin_level] = admin_level
  end

  def admin_level
    self[:admin_level]
  end

end
