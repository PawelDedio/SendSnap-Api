class PushHelper

  def send_android_notification(registration_ids, data, priority, notification)
    push = Rpush::Gcm::Notification.new
    push.app = Rpush::Gcm::App.find_by_name('android_app')
    push.registration_ids = registration_ids
    push.data = data
    push.priority = priority
    push.content_available = true
    push.notification = notification
    push.save!
  end
end