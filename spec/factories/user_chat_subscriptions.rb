FactoryGirl.define do
  factory :user_chat_subscription do
    user_id { (create :user).id }
    participant_id { (create :user).id }
  end
end
