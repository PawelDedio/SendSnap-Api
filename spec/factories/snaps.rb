FactoryGirl.define do
  factory :photo_snap, class: :snap do
    user_id { (create :user).id }
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg')) }
    duration 10
    file_type SNAP_TYPE_PHOTO
    recipient_ids { [(user = create :user
                     author = User.find_by_id(user_id)
                     author.friend_ids = user.id
                     author.save
                     user).id] }
  end

  factory :video_snap, class: :snap do
    user_id { (create :user).id }
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg')) }
    duration 10
    file_type SNAP_TYPE_VIDEO
    recipient_ids { [(user = create :user
                     author = User.find_by_id(user_id)
                     author.friend_ids = user.id
                     author.save
                     user).id] }
  end
end
