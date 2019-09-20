class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :created_at
  has_many :contacts, serializer: ContactSerializer
end
