class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, uniqueness: true, length: {minimum: USER_NAME_MIN_LENGTH, maximum: USER_NAME_MAX_LENGTH}
  validates :display_name, allow_blank: true, length: {minimum: USER_DISPLAY_NAME_MIN_LENGTH, maximum: USER_DISPLAY_NAME_MAX_LENGTH}
  validates :email, presence: true, uniqueness: true, email: {strict_mode: true}
  validates :terms_accepted, presence: true, inclusion: {in: [false, true]}
  validates :role, presence: true, inclusion: {in: [USER_ROLE_ADMIN, USER_ROLE_USER]}
end
