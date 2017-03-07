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
      second = create :user
      third = create :user

      user.friend_ids = [first.id, second.id]
      user.save

      get :index
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count).to be 2
    end

    it 'should print all user friends for admin role' do
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

    it 'should not allow for not authorized user' do
      get :index

      expect(response).to have_http_status :unauthorized
    end
  end
end
