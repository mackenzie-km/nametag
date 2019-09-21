class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :major, :user, :created_at
  has_many :events, serializer: EventSerializer
end
