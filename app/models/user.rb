class User < ApplicationRecord
  has_many :contacts
  has_secure_password

  def name
    self.email[/[^@]*/]
  end

  def admin_level=(code)
    if code == ENV['ADMIN']
      self[:admin_level] = "admin"
    elsif code == ENV['IGSM']
      self[:admin_level] = "igsm"
    else
      self[:admin_level] = "none"
    end
  end

  def admin_level
    self[:admin_level]
  end
end
