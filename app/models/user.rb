class User < ApplicationRecord
  before_create :set_auth_token
  has_secure_password

  validates :name, presence: true, uniqueness: true, length: {minimum: USER_NAME_MIN_LENGTH, maximum: USER_NAME_MAX_LENGTH}
  validates :display_name, allow_blank: true, length: {minimum: USER_DISPLAY_NAME_MIN_LENGTH, maximum: USER_DISPLAY_NAME_MAX_LENGTH}
  validates :email, presence: true, uniqueness: true, email: {strict_mode: true}
  validates :terms_accepted, presence: true, inclusion: {in: [false, true]}
  validates :role, presence: true, inclusion: {in: [USER_ROLE_ADMIN, USER_ROLE_USER]}


  def set_auth_token
    self.auth_token = SecureRandom.uuid.gsub(/\-/,'')
    extend_token_time
  end

  def extend_token_time
    self.token_expire_time = Date.today if self.token_expire_time.nil?
    self.token_expire_time += AUTH_TOKEN_TIME_LENGTH
  end
end
