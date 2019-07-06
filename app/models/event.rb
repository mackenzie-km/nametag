class Event < ApplicationRecord
  has_many :contacts_events
  has_many :contacts, through: :contacts_events
  validates :name, presence: true
  validates :date, presence: true

  scope :access, -> (admin_level) { where('admin_level <= ?', admin_level) }

  def date_human
    self.date.strftime("%B %-d, %Y")
  end


end
