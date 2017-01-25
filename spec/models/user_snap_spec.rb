require 'rails_helper'

RSpec.describe UserSnap, type: :model do
  it 'should pass validation with correct data' do
    model = create :user_snap
    res = model.save

    expect(res).to be true
  end

  describe 'validate user_id' do
    it 'should validate uniqueness' do
      create :user_snap
      should validate_uniqueness_of(:user_id).scoped_to(:snap_id).case_insensitive
    end
  end

  describe 'validate view_count' do
    it 'should validate presence' do
      should validate_presence_of(:view_count)
    end

    it 'should validate numericality' do
      should validate_numericality_of(:view_count)
    end
  end

  describe 'validate last_viewed_at' do
    it 'should validate presence if count is greater than 0' do
      snap = build :user_snap
      snap.view_count = 1
      snap.last_viewed_at = nil

      res = snap.save

      expect(res).to be false
    end
  end
end
