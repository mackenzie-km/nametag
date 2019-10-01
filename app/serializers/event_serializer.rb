class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :created_at, :staff_count, :guest_count
  has_many :contacts, serializer: ContactSerializer
end
