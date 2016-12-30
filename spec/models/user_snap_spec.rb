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
end
