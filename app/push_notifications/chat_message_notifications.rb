class ChatMessageNotifications

  def self.message_received(message, message_json)
    data = {type: NOTIFICATION_MESSAGE_RECEIVED, message: message_json}
    PushHelper.send_notification [message.recipient], data, :high
  end

  def self.message_read(message)
    data = {type: NOTIFICATION_MESSAGE_READ, id: message.id}
    PushHelper.send_notification [message.author], data, :low
  end
end