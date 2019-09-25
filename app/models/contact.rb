class Contact < ApplicationRecord
  belongs_to :user
  has_many :contacts_events
  has_many :events, through: :contacts_events

  validates :name, presence: true

  scope :active, -> { where('updated_at >= ?', Date.today - 3.month) }
  scope :same_level, -> (admin_level) { where('admin_level = ?', admin_level) }
  scope :yours, -> (user_id) { where('user_id = ?', user_id)}
  scope :newsletter_pending, -> (admin_level) { where("newsletter = ? AND email <> ? AND unsubscribed = ? AND admin_level <= ?", false, "", false, admin_level) }
  scope :unsubscribed, -> (admin_level) { where("unsubscribed = ? AND updated_at > ? AND admin_level <= ?", true, 1.month.ago, admin_level) }

  def self.update_newsletter_status(contacts)
    contacts.each do |contact|
      contact.newsletter = true
      contact.save
    end
  end

  def event_id=(id)
    if !id.empty?
      @event = Event.find_by(id: id)
      if (!!@event && (@event.admin_level <= self.user.admin_level)) then self.events << @event end
    end
  end

  def admin_level=(user)
    self[:admin_level] = user.admin_level
  end

  def admin_level
    self[:admin_level]
  end

  def user_name
    self.user.name if self.user
  end
end
