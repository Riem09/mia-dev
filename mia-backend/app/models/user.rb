class User < ActiveRecord::Base

  has_secure_password

  mount_uploader :avatar, ImageUploader

  has_many :videos, :foreign_key => :owner_id
  has_many :video_motifs, :foreign_key => :owner_id

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true, presence: true, email: { mx: true, disposable: true, blacklist: true }
  validates :password_digest, presence: true
  validates :reset_password_token, uniqueness: true, format: { with: /\A[0-9a-f\-]{36}\z/i }, allow_nil: true
  validates :reset_password_sent_at, date: true, allow_nil: true
  validates :confirmation_token, uniqueness: true, presence: true, format: { with: /\A[0-9a-f\-]{36}\z/i }
  validates :confirmed_at, date: true, allow_nil: true
  validates :admin, inclusion: { in: [true, false] }
  validates :api_key, uniqueness: true, presence: true, format: { with: /\A[0-9a-f\-]{36}\z/i }

  scope :pending,   -> { where("confirmed_at IS NULL") }
  scope :confirmed, -> { where("confirmed_at IS NOT NULL") }
  scope :admins,    -> { where("admin = true") }

  before_validation do
    if self.new_record?
      self.confirmation_token = SecureRandom.uuid 
      self.api_key = SecureRandom.uuid
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def admin?
    admin == true
  end

  def set_password!(new_password)
    self.password = new_password
    self.password_confirmation = new_password
    self.reset_password_token = nil
    self.api_key = SecureRandom.uuid
    return self.save
  end

  def reset_password!
    self.reset_password_token = SecureRandom.uuid
    self.reset_password_sent_at = DateTime.now
    if self.save
      UserMailer.reset_password(user: self).deliver_now
      return true
    else
      return false
    end
  end

  def send_invite_email!(password:)
    UserMailer.invite(user: self, password: password).deliver_now
  end

  def self.authenticate(email:, password:)
    user = User.find_by_email(email)
    if user.is_a?(User) && user.authenticate(password)
      return user
    else
      return false
    end
  end

  def self.reset_password!(email:)
    user = User.find_by_email(email)
    if user.is_a?(User)
      return user.reset_password!
    else
      return false
    end
  end

end
