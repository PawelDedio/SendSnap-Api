# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  def subscribed(data)
    stop_all_streams
    stream_from(stream_message_sent(data[MESSAGE_RECIPIENT_ID]))
    stream_from(stream_message_typing(data[MESSAGE_RECIPIENT_ID]))
    stream_from(stream_message_readed(data[MESSAGE_RECIPIENT_ID]))
    current_user.user_chat_subscriptions.create(participant_id: data[MESSAGE_RECIPIENT_ID])
  end

  def unsubscribed
    stop_all_streams
    current_user.user_chat_subscriptions.destroy_all
  end

  def typing(data)
    ActionCable.server.broadcast stream_message_typing(data[MESSAGE_AUTHOR_ID])
  end
end
