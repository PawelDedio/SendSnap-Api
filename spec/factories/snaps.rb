FactoryGirl.define do
  factory :photo_snap, class: :snap do
    user_id { (create :user).id }
    file_type { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg')) }
    duration 10
    type SNAP_TYPE_PHOTO
    recipient_ids { [(create :user).id] }
  end

  factory :video_snap, class: :snap do
    user_id { (create :user).id }
    file_type { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg')) }
    duration 10
    type SNAP_TYPE_VIDEO
    recipient_ids { [(create :user).id] }
  end
end
