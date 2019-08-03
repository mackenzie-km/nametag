class Contact < ApplicationRecord
  belongs_to :user
  has_many :contacts_events
  has_many :events, through: :contacts_events

  validates :name, presence: true

  scope :active, -> { where('updated_at >= ?', Date.today - 3.month) }
  scope :access, -> (admin_level) { where('admin_level <= ?', admin_level) }
  scope :yours, -> (user_id) { where('user_id = ?', user_id)}
  scope :newsletter_pending, -> { where("newsletter = ? AND email <> ?", false, "") }
  scope :unsubscribed, -> { where("unsubscribed = ? AND updated_at > ?", true, 1.month.ago) }

  def self.add_contacts(params, event, user)
    if !params[:contact_ids].empty?
      params[:contact_ids].reject!(&:empty?)
      params[:contact_ids].collect do |c_id|
        if Contact.find_by(id: c_id).admin_level <= user.admin_level
          ContactsEvent.find_or_create_by(contact_id: c_id.to_i, event_id: event.id)
        end
      end
    end
  end

  def event_id=(id)
    if !id.empty?
      @event = Event.find_by(id: id)
      if (!!@event && has_access?(@event.admin_level)) then @contact.events << @event end
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
