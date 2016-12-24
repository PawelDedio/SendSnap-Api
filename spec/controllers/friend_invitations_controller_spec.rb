require 'rails_helper'

RSpec.describe FriendInvitationsController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      should route(:get, 'friend_invitations').to(action: :index)
    }

    it {
      should route(:get, 'friend_invitations/from_me').to(action: :from_me)
    }

    it {
      should route(:get, 'friend_invitations/to_me').to(action: :to_me)
    }

    it {
      should route(:post, 'friend_invitations').to(action: :create)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:put, "friend_invitations/#{uuid}/accept").to(action: :accept, id: uuid)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:put, "friend_invitations/#{uuid}/reject").to(action: :reject, id: uuid)
    }
  end

  describe 'GET #index' do
    it 'should allow for admin role' do
      user = sign_in_user

      invitation = create :friend_invitation

      get :index

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].size).to eql 1
    end

    it 'should not allow for not admin role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      invitation = create :friend_invitation

      get :index

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for unauthorized user' do
      get :index

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'GET #from_me' do
    it 'should return only invitations from current user' do
      user = sign_in_user

      first = build :friend_invitation
      first.author_id = user.id
      first.save

      second = build :friend_invitation
      second.recipient_id = user.id
      second.save

      third = create :friend_invitation

      get :from_me

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count).to eql 1
      expect(parsed_response[COLLECTION_LABEL].first['author_id']).to eql user.id
    end

    it 'should not allow for unauthorized user' do
      get :from_me

      expect(response).to have_http_status :unauthorized
    end

    it 'should allow for not admin role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      get :from_me

      expect(response).to have_http_status :success
    end
  end

  describe 'GET #to_me' do
    it 'should return only invitations to current user' do
      user = sign_in_user

      first = build :friend_invitation
      first.recipient_id = user.id
      first.save

      second = build :friend_invitation
      second.author_id = user.id
      second.save

      third = create :friend_invitation

      get :to_me

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count).to eql 1
      expect(parsed_response[COLLECTION_LABEL].first['recipient_id']).to eql user.id
    end

    it 'should not allow for unauthorized user' do
      get :to_me

      expect(response).to have_http_status :unauthorized
    end

    it 'should allow for not admin role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      get :to_me

      expect(response).to have_http_status :success
    end
  end

  describe 'POST #create' do
    it 'should return success for correct data' do
      sign_in_user

      invitation = build :friend_invitation

      post :create, params: invitation.attributes

      expect(response).to have_http_status :success
    end

    it 'should set author_id to current user' do
      user = sign_in_user

      invitation = build :friend_invitation

      post :create, params: invitation.attributes

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['author_id']).to eql user.id
    end

    it 'should allow for user role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      invitation = build :friend_invitation

      post :create, params: invitation.attributes

      expect(response).to have_http_status :success
    end

    it 'should not allow for unauthorized user' do
      invitation = build :friend_invitation

      post :create, params: invitation.attributes

      expect(response).to have_http_status :unauthorized
    end

    it 'should return bad request for wrong data' do
      sign_in_user

      invitation = build :friend_invitation
      invitation.recipient_id = nil

      post :create, params: invitation.attributes

      expect(response).to have_http_status :bad_request
    end

    it 'should not allow to make duplications' do
      sign_in_user

      invitation = build :friend_invitation

      post :create, params: invitation.attributes

      expect(response).to have_http_status :success

      post :create, params: invitation.attributes

      expect(response).to have_http_status :bad_request
    end
  end

  describe 'put #accept' do
    it 'should allow to accept invitation where user is recipient' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      invitation = build :friend_invitation
      invitation.recipient_id = user.id
      invitation.save

      put :accept, params: {id: invitation.id}
      invitation.reload

      expect(response).to have_http_status :success
      expect(invitation.accepted_at).to_not be nil
    end

    it 'should not allow to accept invitation of another user for user role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      invitation = create :friend_invitation

      put :accept, params: {id: invitation.id}
      invitation.reload

      expect(response).to have_http_status :forbidden
    end

    it 'should allow to accept invitation of another user for admin role' do
      user = sign_in_user
      user.role = USER_ROLE_ADMIN
      user.save

      invitation = create :friend_invitation

      put :accept, params: {id: invitation.id}
      invitation.reload

      expect(response).to have_http_status :success
      expect(invitation.accepted_at).to_not be nil
    end

    it 'should not allow to accept invitation where user is author' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      invitation = build :friend_invitation
      invitation.author_id = user.id
      invitation.save

      put :accept, params: {id: invitation.id}

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow for unauthorized user' do
      invitation = create :friend_invitation

      put :accept, params: {id: invitation.id}

      expect(response).to have_http_status :unauthorized
    end
  end

  describe ''
end
