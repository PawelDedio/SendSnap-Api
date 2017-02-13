FactoryGirl.define do
  factory :chat_message do
    author_id {(create(:user)).id}
    recipient_id { (user = create :user
                    author = User.find_by_id(author_id)
                    author.friend_ids = user.id
                    author.save
                    user).id }
    message {Faker::Lorem.sentence}
  end
end
