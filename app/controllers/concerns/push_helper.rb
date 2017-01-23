class PushHelper

  def self.send_notification(recipients, data, priority)
    android_recipients = []
    recipients.each do |recipient|
      android_recipients << recipient.user_devices.where(device_type: ANDROID_DEVICE).select(:registration_id)
    end

    send_android_notification android_recipients, data, priority
  end

  def self.send_android_notification(registration_ids, data, priority)
    push = Rpush::Gcm::Notification.new
    push.app = Rpush::Gcm::App.find_by_name(ANDROID_DEVICE)
    push.registration_ids = registration_ids
    push.data = data
    push.priority = priority
    push.content_available = true
    push.save!

    Rpush.push
  end
end