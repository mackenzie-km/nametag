class User < ApplicationRecord
  has_many :contacts
  validates :email, presence: true
  validates :email, format: { with: /\A\S+@.+\.\S+\z/ }
  validates :email, uniqueness: { message: "already taken. Try logging in with Google?" } 
  validates :password, format: { with: /\A(?=.*\d).{6,}\z/,
    message: "must be > 6 characters long & include > 1 number" }, allow_nil: true

  has_secure_password

  scope :same_level, -> (admin_level) { where('admin_level = ?', admin_level) }

  def name
    self.email[/[^@]*/]
  end

# compares user-provided code to secret ENV code and sets admin level appropriately
  def admin_level=(code)
    if code == ENV['ADMIN']
      self[:admin_level] = 2
    elsif code == ENV['IGSM']
      self[:admin_level] = 1
    else
      self[:admin_level] = 0
    end
  end

  def admin_level
    self[:admin_level]
  end

# creates a user from omniauth, setting credentials appropriately
  def self.from_omniauth(auth)
    @user = User.where(email: auth.info.email).first_or_initialize
    @user.admin_level=(ENV['IGSM']) if @user.email.include?("@gpmail.org")
    @user.password = SecureRandom.hex
    @user.save
    @user
  end
end
