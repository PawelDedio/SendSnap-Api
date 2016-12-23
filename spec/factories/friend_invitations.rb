FactoryGirl.define do
  factory :friend_invitation do
    author_id { (create :user).id }
    recipient_id { (create :user).id }
  end
end
