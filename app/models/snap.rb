# == Schema Information
#
# Table name: snaps
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  snap_file  :string           not null
#  snap_type  :string           not null
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
  mount_uploaders :snap_file, SnapUploader
end
