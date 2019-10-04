class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :major, :created_at, :gender
  has_many :events, serializer: EventSerializer
  belongs_to :user, serializer: UserSerializer
end
