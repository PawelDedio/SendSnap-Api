# == Schema Information
#
# Table name: users
#
#  id                :uuid             not null, primary key
#  name              :string
#  display_name      :string
#  email             :string
#  terms_accepted    :boolean          default(FALSE)
#  role              :string           default("user")
#  blocked_at        :datetime
#  deleted_at        :datetime
#  auth_token        :string
#  token_expire_time :datetime
#  password_digest   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class User < ApplicationRecord
  before_create :set_auth_token
  has_secure_password

  default_scope {where(deleted_at: nil, blocked_at: nil)}

  validates :name, presence: true, uniqueness: true, length: {minimum: USER_NAME_MIN_LENGTH, maximum: USER_NAME_MAX_LENGTH}
  validates :display_name, allow_blank: true, length: {minimum: USER_DISPLAY_NAME_MIN_LENGTH, maximum: USER_DISPLAY_NAME_MAX_LENGTH}
  validates :email, presence: true, uniqueness: true, email: {strict_mode: true}
  validates :terms_accepted, presence: true, inclusion: {in: [true]}
  validates :role, presence: true, inclusion: {in: [USER_ROLE_ADMIN, USER_ROLE_USER]}

  def sign_in
    set_auth_token
    extend_token_time
  end

  def sign_out
    self.auth_token = nil
    self.token_expire_time = nil
  end

  def set_auth_token
    self.auth_token = SecureRandom.uuid.gsub(/\-/,'')
    extend_token_time
  end

  def extend_token_time
    self.token_expire_time = AUTH_TOKEN_TIME_LENGTH
  end

  def block
    self.blocked_at = Date.today
    self.save
  end

  def delete
    self.deleted_at = Date.today
    self.save
  end
end
