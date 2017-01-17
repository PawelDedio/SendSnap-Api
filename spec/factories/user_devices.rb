FactoryGirl.define do
  factory :android_device, class: UserDevice do
    user_id { (create :user).id }
    registration_id Faker::Code.isbn
    device_type ANDROID_DEVICE
    device_id Faker::Code.imei
  end
end
