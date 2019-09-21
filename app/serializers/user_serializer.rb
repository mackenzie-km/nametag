class UserSerializer < ActiveModel::Serializer
  attributes :email
  has_many :contacts, serializer: ContactSerializer
end
