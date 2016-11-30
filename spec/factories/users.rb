FactoryGirl.define do
  factory :user do
    name {Faker::Name.name[0, USER_NAME_MAX_LENGTH]}
    password {Faker::Internet.password}
    password_confirmation {password}
    display_name {Faker::Name.first_name[0, USER_NAME_MAX_LENGTH]}
    email {Faker::Internet.email}
    terms_accepted true
    role 'user'
  end

  factory :admin do
    name {Faker::Name.name[0, USER_NAME_MAX_LENGTH]}
    password {Faker::Internet.password}
    password_confirmation {password}
    display_name {Faker::Name.first_name[0, USER_NAME_MAX_LENGTH]}
    email {Faker::Internet.email}
    terms_accepted true
    role 'admin'
  end
end
