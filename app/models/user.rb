class User < ApplicationRecord
  has_many :contacts

  def name
    self.email[/[^@]*/]
  end
end
