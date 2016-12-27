# == Schema Information
#
# Table name: friend_invitations
#
#  id           :uuid             not null, primary key
#  author_id    :uuid             not null
#  recipient_id :uuid             not null
#  accepted_at  :datetime
#  rejected_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  canceled_at  :datetime
#
# Indexes
#
#  index_friend_invitations_on_author_id_and_recipient_id  (author_id,recipient_id)
#

class FriendInvitation < ApplicationRecord

  belongs_to :author, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :author_id, presence: true, user: true
  validates :recipient_id, presence: true, user: true, recipient_id: true,
            uniqueness: {scope: :author_id, conditions:  -> {where(canceled_at: nil, rejected_at: nil)}}

  default_scope {where(accepted_at: nil, rejected_at: nil, canceled_at: nil)}


  def accept
    self.accepted_at = Date.today
    self.save
  end

  def reject
    self.rejected_at = Date.today
    self.save
  end

  def cancel
    self.canceled_at = Date.today
    self.save
  end
end
