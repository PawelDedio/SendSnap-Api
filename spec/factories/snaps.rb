FactoryGirl.define do
  factory :photo_snap, class: :snap do
    user_id { (create :user).id }
    #snap_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg')) }
    duration 10
    snap_type SNAP_TYPE_PHOTO
    snap_file ActionDispatch::Http::UploadedFile.new({filename: 'snap.jpg', tempfile: File.join(Rails.root, 'spec', 'attachments', 'snap.jpg')})
  end

  factory :video_snap, class: :snap do
    user_id { (create :user).id }
    snap_file { (Faker::File.file_name 'snaps', 'snap', 'mp4') }
    duration 10
    snap_type SNAP_TYPE_VIDEO
  end
end
