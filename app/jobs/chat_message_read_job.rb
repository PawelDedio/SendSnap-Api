class ChatMessageReadJob < ApplicationJob
  queue_as :default

  def perform(message)
    if message.recipient.user_chat_subscription_ids.include?(message.author_id)
      ActionCable.server.broadcast stream_message_sent(message.recipient_id), id: message.id
    else
      ChatMessageNotifications.message_read message
    end
  end
end
