require 'rails_helper'

RSpec.describe SnapsController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      should route(:get, 'snaps').to(action: :index)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:get, "snaps/#{uuid}").to(action: :show, id: uuid)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:get, "snaps#{uuid}/image").to(action: :show, id: uuid)
    }
  end

  describe 'get #index' do
    it 'should print all snaps for admin role' do
      sign_in_admin

      first = create :photo_snap
      second = create :photo_snap

      get :index
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count.to_i).to eql 2
    end

    it 'should not allow for not admin role' do
      sign_in_user

      get :index

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for unauthorized user' do
      get :index

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'get #show' do
    it 'should allow to see other users snap for admin role' do
      sign_in_admin

      snap = create :photo_snap

      get :show, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should not allow to see other users snap for not admin role' do
      sign_in_user

      snap = create :photo_snap

      get :show, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should allow to see snap where user is author' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user_id = user.id
      snap.save

      get :show, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should allow to see snap where user is recipient' do
      user = sign_in_user

      snap = build :photo_snap
      snap.recipient_ids = [user.id]
      snap.save

      get :show, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'user should not see other recipients when is recipient and not admin' do
      user = sign_in_user

      snap = build :photo_snap
      snap.recipient_ids = [user.id]
      snap.save

      get :show, params: {id: snap.id}
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['recipients']).to be nil
    end

    it 'user should see recipients when is recipient and not admin' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user_id = user.id
      snap.save

      get :show, params: {id: snap.id}
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['recipients']).to_not be nil
    end
  end

  describe 'GET #image' do
    it 'should allow to view for author' do

    end
  end
end
