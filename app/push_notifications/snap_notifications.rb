class SnapNotifications

  def self.snap_received(snap)
    data = {type: NOTIFICATION_SNAP_RECEIVED, from: snap.user.display_name, snap_type: snap.file_type}
    PushHelper.send_notification snap.recipients, data, :high
  end

  def self.snap_viewed(snap, recipient)
    data = {type: NOTIFICATION_SNAP_VIEWED, snap_id: snap.id, by: recipient.id}
    PushHelper.send_notification [snap.user], data, :high
  end

  def self.snap_replayed(snap, recipient)
    data = {type: NOTIFICATION_SNAP_REPLAYED, snap_id: snap.id, by: recipient.id}
    PushHelper.send_notification [snap.user], data, :high
  end

  def self.screenshot_made(snap, recipient)
    data = {type: NOTIFICATION_SNAP_SCREENSHOT_MADE, snap_id: snap.id, by: recipient.id}
    PushHelper.send_notification [snap.user], data, :high
  end
end