require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  it 'chat_message should pass validation with correct data' do
    message = build :chat_message
    val = message.save

    expect(val).to be true
  end

  describe 'validate author_id' do
    it 'should validate presence of' do
      should validate_presence_of(:author_id)
    end
  end

  describe 'validate recipient_id' do
    it 'should validate presence of' do
      should validate_presence_of(:recipient_id)
    end

    it 'should not allow to add the same recipient as author' do
      message = build :chat_message
      message.recipient_id = message.author_id
      val = message.save

      expect(val).to be false
    end

    it 'should not allow to add recipient which is not a friend' do
      message = build :chat_message
      message.recipient_id = (create :user).id
      val = message.save

      expect(val)
    end
  end

  describe 'validate message' do
    it 'should validate presence of' do
      should validate_presence_of(:message)
    end
  end
end
