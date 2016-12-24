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

    it 'should not allow to save duplicated recipient_id for the same author_id' do
      first = create :friend_invitation
      second = build :friend_invitation
      second.author_id = first.author.id
      second.recipient_id = first.recipient_id

      res = second.save

      expect(res).to be false
    end

    it 'should  allow to save duplicated recipient_id for not the same author_id' do
      first = create :friend_invitation
      second = build :friend_invitation
      second.recipient_id = first.recipient_id

      res = second.save

      expect(res).to be true
    end

    it 'should not allow to save recipient which is user friend' do
      user = create :user
      second = create :user
      second.friends << user
      second.save

      invitation = build :friend_invitation
      invitation.author_id = user.id
      invitation.recipient_id = second.id

      res = invitation.save

      expect(res).to be false
    end
  end
end
