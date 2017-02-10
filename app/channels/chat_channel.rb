# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  def subscribed(data)
    stop_all_streams
    stream_from(message_sent_stream(data[MESSAGE_RECIPIENT_ID]))
    stream_from(message_typing_stream(data[MESSAGE_RECIPIENT_ID]))
    stream_from(message_readed_stream(data[MESSAGE_RECIPIENT_ID]))
  end

  def unsubscribed
    stop_all_streams
  end

  def typing(data)
    ActionCable.server.broadcast message_typing_stream(data[MESSAGE_AUTHOR_ID])
  end
end
