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
end
