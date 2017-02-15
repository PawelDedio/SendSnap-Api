# == Schema Information
#
# Table name: chat_messages
#
#  id           :uuid             not null, primary key
#  author_id    :uuid             not null
#  recipient_id :uuid             not null
#  message      :text             not null
#  readed_at    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_chat_messages_on_author_id_and_recipient_id  (author_id,recipient_id)
#

class ChatMessage < ApplicationRecord

  after_commit { ChatMessageReceivedJob.perform_later(self) }

  belongs_to :author, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :author_id, presence: true
  validates :recipient_id, presence: true, message_recipient_id: true
  validates :message, presence: true, length: {minimum: 1}

  def self.thread(user_id, friend_id)
    ChatMessage.where(author_id: [user_id, friend_id], recipient_id: [user_id, friend_id]).distinct
  end

  def self.unread_thread(user_id, friend_id)
    self.thread(user_id, friend_id).where(readed_at: nil)
  end
end
