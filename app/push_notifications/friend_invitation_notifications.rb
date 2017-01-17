class FriendInvitationNotifications

  def self.user_invited(author, recipient)
    name = author.display_name
    name = author.name if name.nil?
    PushHelper.send_notification [recipient], {type: NOTIFICATION_FRIEND_INVITATION, from: name}, :high
  end
end