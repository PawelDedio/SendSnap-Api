FactoryGirl.define do
  factory :chat_message do
    author_id {(create(:user)).id}
    recipient_id {(create(:user)).id}
    message {Faker::Lorem.sentence}
  end
end
