require 'rails_helper'

RSpec.describe UserChatSubscription, type: :model do
  it 'should pass validation with correct data' do
    subscription = build :user_chat_subscription
    val = subscription.save

    expect(val).to be true
  end

  describe 'validate user_id' do
    it 'should validate presence' do
      should validate_presence_of(:user_id)
    end
  end

  describe 'validate participant_id' do
    it 'should validate presence' do
      should validate_presence_of(:participant_id)
    end

    it 'should validate uniqueness' do
      create :user_chat_subscription
      should validate_uniqueness_of(:participant_id).scoped_to(:user_id).case_insensitive
    end
  end
end
