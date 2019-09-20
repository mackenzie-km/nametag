class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at
  has_many :events, serializer: EventSerializer
end
