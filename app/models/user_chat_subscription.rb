# == Schema Information
#
# Table name: user_chat_subscriptions
#
#  id             :uuid             not null, primary key
#  user_id        :uuid
#  participant_id :uuid
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_user_chat_subscriptions_on_participant_id  (participant_id)
#  index_user_chat_subscriptions_on_user_id         (user_id)
#

class UserChatSubscription < ApplicationRecord

  belongs_to :user

  validates :user_id, presence: true
  validates :participant_id, presence: true, uniqueness: {scope: :user_id}
end
