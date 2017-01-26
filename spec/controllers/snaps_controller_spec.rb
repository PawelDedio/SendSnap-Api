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
      should route(:put, "snaps/#{uuid}/view").to(action: :view, id: uuid)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:get, "snaps/#{uuid}/image").to(action: :image, id: uuid)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:put, "snaps/#{uuid}/replay").to(action: :replay, id: uuid)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:put, "snaps/#{uuid}/screenshot").to(action: :screenshot, id: uuid)
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
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      get :show, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'user should not see other recipients when is recipient and not admin' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      get :show, params: {id: snap.id}
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['recipients']).to be nil
    end

    it 'user should see recipients when is author and not admin' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user_id = user.id
      snap.save

      get :show, params: {id: snap.id}
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['recipients']).to_not be nil
    end

    it 'should show view count for recipient' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      get :show, params: {id: snap.id}
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['view_count']).to_not be nil
    end

    it 'should not show view count for author' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user_id = user.id
      snap.save

      get :show, params: {id: snap.id}
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['view_count']).to be nil
    end

    it 'should not allow for unauthorized user' do
      snap = create :photo_snap

      get :show, params: {id: snap.id}

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'PUT #view' do
    it 'should allow to view for recipient user' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      put :view, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should not allow to view for author user' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user_id = user.id
      snap.save

      put :view, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow to view for admin' do
      sign_in_admin

      snap = create :photo_snap

      put :view, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should allow to view for recipient admin' do
      user = sign_in_admin

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      put :view, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should increment view count for current recipient after image view' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      old_count = snap.user_snaps.find_by_user_id(user.id).view_count

      put :view, params: {id: snap.id}

      new_count = snap.user_snaps.find_by_user_id(user.id).view_count

      expect(new_count - old_count).to eql 1
    end

    it 'should not allow for unauthorized user' do
      snap = create :photo_snap

      put :view, params: {id: snap.id}

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'get #image' do
    it 'should allow for recipient when view_count less than 1 for user role' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      association = snap.user_snaps.find_by_user_id(user.id)
      association.view_count = 0
      association.save

      get :image, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should allow for recipient when view_count less than 1 for admin role' do
      user = sign_in_admin

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      association = snap.user_snaps.find_by_user_id(user.id)
      association.view_count = 0
      association.save

      get :image, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should not allow for recipient when view_count more than 0' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      association = snap.user_snaps.find_by_user_id(user.id)
      association.view_count = 1
      association.last_viewed_at = DateTime.now
      association.save

      get :image, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for not authorized user' do
      snap = create :photo_snap

      get :image, params: {id: snap.id}

      expect(response).to have_http_status :unauthorized
    end

    it 'should not allow to view another user snap for user role' do
      sign_in_user

      snap = create :photo_snap

      get :image, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow to view another user snap for admin role' do
      sign_in_admin

      snap = create :photo_snap

      get :image, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end
  end

  describe 'post #create' do
    it 'should return success for correct photo data' do
      sign_in_user

      snap = build :photo_snap
      file = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg'))

      post :create, params: snap.attributes.merge({recipient_ids: snap.recipient_ids, file: file})

      expect(response).to have_http_status :success
    end

    it 'should return success for correct video data' do
      sign_in_user

      snap = build :video_snap
      file = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg'))

      post :create, params: snap.attributes.merge({recipient_ids: snap.recipient_ids, file: file})

      expect(response).to have_http_status :success
    end

    it 'should return bad request for bad data' do
      sign_in_user

      snap = build :photo_snap
      snap.file = nil

      post :create, params: snap.attributes

      expect(response).to have_http_status :bad_request
    end

    it 'should not allow for unauthorized user' do
      snap = build :video_snap
      file = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'attachments', 'snap.jpg'))

      post :create, params: snap.attributes.merge({recipient_ids: snap.recipient_ids, file: file})

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'put #replay' do
    it 'should allow when user is recipient' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save
      snap.view user.id

      put :replay, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should allow when admin is recipient' do
      user = sign_in_admin

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save
      snap.view user.id

      put :replay, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should not allow when last_viewed_at is older than hour ago' do
      user = sign_in_admin

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save
      snap.view user.id

      user_snap = snap.user_snaps.find_by_user_id(user.id)
      user_snap.last_viewed_at = Date.today - 2.hour
      user_snap.save

      put :replay, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should allow only one replay per day' do
      user = sign_in_user
      user.last_replay_at = DateTime.now
      user.save

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save
      snap.view user.id

      put :replay, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for not recipient' do
      sign_in_admin

      snap = create :photo_snap

      put :replay, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for author' do
      user = sign_in_user

      snap = build :photo_snap
      snap.user = user
      snap.save

      put :replay, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for unauthorized user' do
      snap = create :photo_snap

      put :replay, params: {id: snap.id}

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'put #screenshot' do
    it 'should allow when admin is recipient' do
      user = sign_in_admin

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      put :screenshot, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should allow when user is recipient' do
      user = sign_in_admin

      snap = build :photo_snap
      snap.user.friend_ids = user.id
      snap.recipient_ids = [user.id]
      snap.save

      put :screenshot, params: {id: snap.id}

      expect(response).to have_http_status :success
    end

    it 'should not allow for not recipient' do
      user = sign_in_admin

      snap = create :photo_snap

      put :screenshot, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for author' do
      user = sign_in_admin

      snap = build :photo_snap
      snap.user = user
      snap.save

      put :screenshot, params: {id: snap.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for unauthorized user' do
      snap = create :photo_snap

      put :screenshot, params: {id: snap.id}

      expect(response).to have_http_status :unauthorized
    end
  end
end
