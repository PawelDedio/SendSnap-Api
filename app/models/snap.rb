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
  validates :recipient_ids, presence: true
end
