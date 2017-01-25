class FriendInvitationNotifications

  def self.notification_received(author, recipient)
    data = {type: NOTIFICATION_INVITATION_RECEIVED, from: author.display_name}
    PushHelper.send_notification [recipient], data, :high
  end

  def self.invitation_accepted(author, recipient)
    data = {type: NOTIFICATION_INVITATION_ACCEPTED, from: author.display_name}
    PushHelper.send_notification [author], data, :high
  end

  def self.invitation_rejected(author, recipient)
    data = {type: NOTIFICATION_INVITATION_REJECTED, from: author.display_name}
    PushHelper.send_notification [author], data, :high
  end
end