require 'rails_helper'

RSpec.describe ChatMessagesController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:get, "chat_messages/thread/#{uuid}").to(action: :thread, participant: uuid)
    }

    it {
      should route(:post, 'chat_messages').to(action: :create)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:put, "chat_messages/#{uuid}/read").to(action: :read, id: uuid)
    }
  end

  describe 'get #thread' do
    it 'should return only unread messages' do
      recipient = sign_in_user
      author = create :user
      recipient.friends << author
      recipient.save

      first = build :chat_message
      first.author = author
      first.recipient_id = recipient.id
      first.readed_at = DateTime.now
      first.save
      second = build :chat_message
      second.author = author
      second.recipient_id = recipient.id
      second.save

      get :thread, params: {participant: author.id}
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count.to_i).to eql 1
    end

    it 'should not allow to get messages from user which is not a friend' do
      recipient = sign_in_user
      author = create :user

      get :thread, params: {participant: author.id}
      parsed_response = JSON.parse(response.body)

      expect(parsed_response[COLLECTION_LABEL].count.to_i).to eql 0
    end

    it 'should not allow for unauthorized user' do
      author = create :user

      get :thread, params: {participant: author.id}

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'post #create' do
    it 'should return success for correct data' do
      author = sign_in_user
      recipient = build :user
      recipient.friends << author
      recipient.save

      message = build :chat_message
      message.recipient_id = recipient.id

      post :create, params: message.attributes

      expect(response).to have_http_status :success
    end

    it 'should assign current logged user as a author' do
      logged_user = sign_in_user
      author = create :user
      recipient = build :user
      recipient.friends << logged_user
      recipient.save

      message = build :chat_message
      message.author_id = author.id
      message.recipient_id = recipient.id

      post :create, params: message.attributes
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['author_id']).to eql logged_user.id
    end

    it 'should not allow for unauthorized user' do
      message = create :chat_message

      post :create, params: message.attributes

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'put #read' do
    it 'should set message as a read when user is recipient' do
      recipient = sign_in_user
      author = build :user
      author.friends << recipient
      author.save

      message = build :chat_message
      message.author_id = author.id
      message.recipient_id = recipient.id
      message.save

      put :read, params: message.attributes
      message.reload

      expect(response).to have_http_status :success
      expect(message.readed_at).to_not be nil
    end

    it 'should set older messages as a read' do
      recipient = sign_in_user
      author = build :user
      author.friends << recipient
      author.save

      first = build :chat_message
      first.author_id = author.id
      first.recipient_id = recipient.id
      first.readed_at = nil
      first.save

      second = build :chat_message
      second.author_id = author.id
      second.recipient_id = recipient.id
      second.save

      put :read, params: second.attributes
      first.reload

      expect(first.readed_at).to_not be nil
    end

    it 'should not allow to set message as a read when user is author' do
      author = sign_in_user
      recipient = build :user
      recipient.friends << author
      recipient.save

      message = build :chat_message
      message.author_id = author.id
      message.recipient_id = recipient.id
      message.save

      put :read, params: message.attributes

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow to set message as a read when admin is author' do
      author = sign_in_admin
      recipient = build :user
      recipient.friends << author
      recipient.save

      message = build :chat_message
      message.author_id = author.id
      message.recipient_id = recipient.id
      message.save

      put :read, params: message.attributes

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow to set another user message as a read for user role' do
      sign_in_user

      message = create :chat_message

      put :read, params: message.attributes

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow to set another user message as a read for admin role' do
      sign_in_admin

      message = create :chat_message

      put :read, params: message.attributes

      expect(response).to have_http_status :forbidden
    end
  end
end
