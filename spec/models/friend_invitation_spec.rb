require 'rails_helper'

RSpec.describe FriendInvitation, type: :model do

  it 'should pass validation with correct data' do
    invitation = build :friend_invitation
    res = invitation.save

    expect(res).to be true
  end

  describe 'validate author_id' do
    it 'should validate presence of author_id' do
      should validate_presence_of(:author_id)
    end

    it 'should not allow to save wrong id' do
      invitation = build :friend_invitation
      invitation.author_id = 'wrong id'

      res = invitation.save

      expect(res).to be false
    end
  end

  describe 'validate recipient_id' do
    it 'should validate presence of recipient_id' do
      should validate_presence_of(:recipient_id)
    end

    it 'should not allow to save wrong id' do
      invitation = build :friend_invitation
      invitation.recipient_id = invitation.author_id

      res = invitation.save

      expect(res).to be false
    end

    it 'should not allow to save the same id as author_id' do
      invitation = build :friend_invitation
      invitation.recipient_id = 'wrong id'

      res = invitation.save

      expect(res).to be false
    end
  end
end
