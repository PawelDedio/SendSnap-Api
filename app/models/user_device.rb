# == Schema Information
#
# Table name: user_devices
#
#  id              :uuid             not null, primary key
#  user_id         :uuid             not null
#  registration_id :string           not null
#  device_type     :string           not null
#  device_id       :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_devices_on_device_type  (device_type)
#  index_user_devices_on_user_id      (user_id)
#

class UserDevice < ApplicationRecord

  belongs_to :user

  validates :user_id, presence: true
  validates :registration_id, presence: true
  validates :device_type, presence: true, inclusion: {in: [ANDROID_DEVICE]}
  validates :device_id, presence: true, uniqueness: {scope: :user_id}
end
