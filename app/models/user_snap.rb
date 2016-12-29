# == Schema Information
#
# Table name: user_snaps
#
#  id         :integer          not null, primary key
#  user_id    :uuid             not null
#  snap_id    :uuid             not null
#  view_count :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_snaps_on_user_id_and_snap_id  (user_id,snap_id)
#

class UserSnap < ApplicationRecord
  belongs_to :user
  belongs_to :snap

  validates :user, presence: true, uniqueness: {scope: :snap_id}
  validates :snap, presence: true
end
