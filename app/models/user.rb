class User < ApplicationRecord
  has_many :contacts
  has_secure_password

  def name
    self.email[/[^@]*/]
  end

  def access_code
    if :access_code == ENV['ADMIN']
      self.admin_level = "admin"
    elsif :access_code == ENV['IGSM']
      self.admin_level = "igsm"
    else
      self.admin_level = "none"
    end
  end
end
