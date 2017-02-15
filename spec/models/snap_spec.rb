require 'rails_helper'

RSpec.describe Snap, type: :model do
  it 'photo_snap should pass validation with correct data' do
    snap = build :photo_snap
    val = snap.save

    expect(val).to be true
  end

  it 'video_snap should pass validation with correct data' do
    snap = build :video_snap
    val = snap.save

    expect(val).to be true
  end

  describe 'validate user_id' do
    it 'should validate presence' do
      should validate_presence_of(:user_id)
    end
  end

  describe 'validate file' do
    it 'should validate presence' do
      should validate_presence_of(:file)
    end

    it 'should generate url after success upload' do
      snap = build :photo_snap
      snap.save

      expect(snap.file.url).to_not be nil
    end
  end

  describe 'validate type' do
    it 'should validate presence' do
      should validate_presence_of(:file_type)
    end

    it 'should allow only valid type' do
      snap = build :photo_snap
      snap.file_type = SNAP_TYPE_PHOTO
      res = snap.save
      expect(res).to be true

      snap.file_type = SNAP_TYPE_VIDEO
      res = snap.save
      expect(res).to be true

      snap.file_type = 'wrong type'
      res = snap.save
      expect(res).to be false
    end
  end

  describe 'validate duration' do
    it 'should validate presence' do
      should validate_presence_of(:duration)
    end

    it 'should not allow not numbers' do
      snap = build :photo_snap
      snap.duration = 'not a number'
      res = snap.save

      expect(res).to be false
    end
  end

  describe 'recipient_ids' do
    it 'should validate presence' do
      should validate_presence_of(:recipient_ids)
    end

    it 'should not allow to add recipient which is not a friend' do
      snap = build :photo_snap
      snap.recipient_ids = [(create :user).id]
      res = snap.save

      expect(res).to be false
    end
  end
end
