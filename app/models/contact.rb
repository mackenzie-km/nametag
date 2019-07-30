class Contact < ApplicationRecord
  belongs_to :user
  has_many :contacts_events
  has_many :events, through: :contacts_events

  validates :name, presence: true

  scope :active, -> { where('updated_at >= ?', Date.today - 3.month) }

  scope :access, -> (admin_level) { where('admin_level <= ?', admin_level) }

  def self.add_contacts(params, event, user)
    if params[:contact_ids]
      ContactsEvent.where(event_id: event.id).delete_all
      params[:contact_ids].collect do |c_id|
        if Contact.find_by(id: c_id).admin_level <= user.admin_level
          ContactsEvent.find_or_create_by(contact_id: c_id.to_i, event_id: event.id)
        end
      end
    end
  end

  def event_id=()
    self.events << Event.find(value)
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
