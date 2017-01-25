# == Schema Information
#
# Table name: user_snaps
#
#  id             :uuid             not null, primary key
#  user_id        :uuid             not null
#  snap_id        :uuid             not null
#  view_count     :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  last_viewed_at :datetime
#  screenshot_at  :datetime
#
# Indexes
#
#  index_user_snaps_on_user_id_and_snap_id  (user_id,snap_id)
#

class UserSnap < ApplicationRecord
  belongs_to :user
  belongs_to :snap

  validates :user_id, uniqueness: {scope: :snap_id}
  validates :view_count, presence: true, numericality: true
  validates :last_viewed_at, presence: true, if: -> (user_snap) {user_snap.view_count.present? && user_snap.view_count > 0}
end
