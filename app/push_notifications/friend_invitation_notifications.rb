class FriendInvitationNotifications

  def self.user_invited(author, recipient)
    name = author.display_name
    name = author.name if name.nil?
    PushHelper.send_notification [recipient], {type: NOTIFICATION_FRIEND_INVITATION, from: name}, :high
  end

  def self.invitation_accepted(author, recipient)
    name = recipient.display_name
    name = recipient.name if name.nil?

    PushHelper.send_notification [author], {type: NOTIFICATION_INVITATION_ACCEPTED, from: name}, :high
  end

  def self.invitation_rejected(author, recipient)
    name = recipient.display_name
    name = recipient.name if name.nil?

    PushHelper.send_notification [author], {type: NOTIFICATION_INVITATION_REJECTED, from: name}, :high
  end
end