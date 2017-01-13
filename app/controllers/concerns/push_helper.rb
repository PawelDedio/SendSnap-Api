class PushHelper

  def send_android_notification(registration_ids, data, priority, notification)
    notification = Rpush::Gcm::Notification.new
    notification.app = Rpush::Gcm::App.find_by_name('android_app')
    notification.registration_ids = registration_ids
    notification.data = data
    notification.priority = priority
    notification.content_available = true
    notification.notification = notification
    notification.save!
  end
end