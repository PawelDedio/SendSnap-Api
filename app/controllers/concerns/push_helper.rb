class PushHelper

  def self.send_notification(recipients, data, priority)
    android_recipients = recipients.eager_load(:user_device).where(device_type: ANDROID_DEVICE).select(:registration_id)

    send_android_notification android_recipients, data, priority, notification
  end

  def self.send_android_notification(registration_ids, data, priority, notification)
    push = Rpush::Gcm::Notification.new
    push.app = Rpush::Gcm::App.find_by_name(ANDROID_DEVICE)
    push.registration_ids = registration_ids
    push.data = data
    push.priority = priority
    push.content_available = true
    push.notification = notification
    push.save!

    Rpush.push
  end
end