require 'rails_helper'

RSpec.describe FriendsController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      should route(:get, 'friends').to(action: :index)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:delete, "friends/#{uuid}").to(action: :destroy, id: uuid)
    }
  end

  describe 'get #index' do
    it 'should print all user friends for user role' do
      user = sign_in_user

      first = create :user
      second = build :user
      second.friend_ids = [user.id]
      second.save
      third = create :user

      user.friend_ids = [first.id]
      user.save

      get :index
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count).to be 2
    end

    it 'should print all user friends for admin role' do
      user = sign_in_admin

      first = create :user
      second = build :user
      second.friend_ids = [user.id]
      second.save
      third = create :user

      user.friend_ids = [first.id]
      user.save

      get :index
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count).to be 2
    end

    it 'should not allow for not authorized user' do
      get :index

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'delete #destroy' do
    it 'should allow to delete friend for admin role' do
      user = sign_in_admin

      friend = build :user
      friend.friend_ids = [user.id]
      friend.save

      delete :destroy, params: {id: friend.id}

      expect(response).to have_http_status :success
      expect(user.all_friends.size).to be 0
    end

    it 'should allow to delete friend for user role' do
      user = sign_in_admin

      friend = build :user
      friend.friend_ids = [user.id]
      friend.save

      delete :destroy, params: {id: friend.id}

      expect(response).to have_http_status :success
      expect(user.all_friends.size).to be 0
    end

    it 'should not allow to delete not friend' do
      user = sign_in_admin

      friend = create :user

      delete :destroy, params: {id: friend.id}

      expect(response).to have_http_status :bad_request
    end

    it 'should not allow for unauthorized user' do
      friend = create :user

      delete :destroy, params: {id: friend.id}

      expect(response).to have_http_status :unauthorized
    end
  end
end
