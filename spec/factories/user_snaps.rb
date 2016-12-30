FactoryGirl.define do
  factory :user_snap do
    user_id { (create :user).id }
    snap_id { (create :photo_snap).id }
  end
end
