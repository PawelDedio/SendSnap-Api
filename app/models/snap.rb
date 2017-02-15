# == Schema Information
#
# Table name: snaps
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  file       :string           not null
#  file_type  :string           not null
#  duration   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_snaps_on_user_id  (user_id)
#

require 'carrierwave/orm/activerecord'
class Snap < ApplicationRecord
  mount_uploader :file, SnapUploader

  belongs_to :user

  has_many :user_snaps
  has_many :recipients, through: :user_snaps, source: :user

  validates :user_id, presence: true
  validates :file, presence: true
  validates :file_type, presence: true, inclusion: {in: [SNAP_TYPE_PHOTO, SNAP_TYPE_VIDEO]}
  validates :duration, presence: true, numericality: true
  validates :recipient_ids, presence: true, snap_recipients: true


  def all_errors
    errors = self.user_snaps.map do |user_snap|
      user_snap.errors
    end

    self.errors.add(:recipient_ids, errors)
    self.errors
  end

  def view(user_id)
    user_snap = self.user_snaps.find_by_user_id(user_id)
    user_snap.view_count += 1
    user_snap.last_viewed_at = DateTime.now
    user_snap.save
  end

  def replay(user)
    user_snap = self.user_snaps.find_by_user_id(user.id)

    if user_snap.last_viewed_at < 1.hour.ago
      return false
    end
    user_snap.view_count -= 1
    user.last_replay_at = DateTime.now
    user_snap.save && user.save
  end

  def screenshot(user_id)
    user_snap = self.user_snaps.find_by_user_id(user_id)
    user_snap.screenshot_at = DateTime.now
    user_snap.save
  end

  def view_count(user_id)
    self.user_snaps.find_by_user_id(user_id).view_count
  end

  #TODO: Custom url for image view and validation of view_count
end
