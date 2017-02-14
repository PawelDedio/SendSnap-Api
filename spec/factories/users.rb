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

FactoryGirl.define do
  factory :user do
    name {(Faker::Name.first_name + 'aaa')[0, USER_NAME_MAX_LENGTH]}
    password {Faker::Internet.password}
    password_confirmation {password}
    display_name {(Faker::Name.first_name + 'aaa')[0, USER_NAME_MAX_LENGTH]}
    email {Faker::Internet.email}
    terms_accepted true
    role 'user'
  end

  factory :admin, class: User do
    name {(Faker::Name.first_name + 'aaa')[0, USER_NAME_MAX_LENGTH]}
    password {Faker::Internet.password}
    password_confirmation {password}
    display_name {(Faker::Name.first_name + 'aaa')[0, USER_NAME_MAX_LENGTH]}
    email {Faker::Internet.email}
    terms_accepted true
    role 'admin'
  end
end
