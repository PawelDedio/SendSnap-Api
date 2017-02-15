class ChatMessageReceivedJob < ApplicationJob
  queue_as :default

  def perform(message)
    json = ChatMessageSerializer.new(message).to_json
    if message.recipient.user_chat_subscription_ids.include?(message.author_id)
      ActionCable.server.broadcast stream_message_sent(message.author_id),
                                   message: json
    else
      ChatMessageNotifications.message_received message, json
    end
  end
end
