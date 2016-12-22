require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:get, "users/#{uuid}").to(action: :show, id: uuid)
    }
    it {
      should route(:post, 'users').to(action: :create)
    }
  end

  describe 'GET #index' do
    it 'should allow access to user list for admin role' do
      user1 = sign_in_user
      user2 = create :user

      get :index

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status :success
      expect(parsed_response[COLLECTION_LABEL].count.to_i).to eql 2
    end

    it 'should not allow access for not admin role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      get :index

      expect(response).to have_http_status :forbidden
    end

    it 'should not allow access for not authorized user' do
      get :index

      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'GET #show' do
    it 'should allow only authenticated user' do
      user = create :user
      get :show, params: {id: user.id}
      expect(response).to have_http_status :unauthorized
    end

    it 'should show user details for authorized user' do
      user = sign_in_user
      get :show, params: {id: user.id}
      expect(response).to have_http_status :ok
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eql user.id
    end

    it 'should not allow to show another user for not admin role' do
      logged_user = sign_in_user
      logged_user.role = USER_ROLE_USER
      logged_user.save
      user = create :user
      get :show, params: {id: user.id}
      expect(response).to have_http_status :forbidden
    end

    it 'should allow to show another user for admin role' do
      sign_in_user
      user = create :user
      get :show, params: {id: user.id}
      expect(response).to have_http_status :ok
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eql user.id
    end
  end

  describe 'POST #create' do
    it 'should create user with correct data' do
      user = build :user
      password = {password: 'qqqqqqqq', password_confirmation: 'qqqqqqqq'}

      post :create, params: user.attributes.merge(password)
      expect(response).to have_http_status :created
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['name']).to eql user.name
    end

    it 'should not allow create with incorrect data' do
      user = build :user
      password = {password: 'qqqqqqqq', password_confirmation: 'not_match_password'}

      post :create, params: user.attributes.merge(password)
      expect(response).to have_http_status :bad_request
    end

    it 'should not allow to assign admin role' do
      user = build :user
      user.role = USER_ROLE_ADMIN
      password = {password: 'qqqqqqqq', password_confirmation: 'qqqqqqqq'}

      post :create, params: user.attributes.merge(password)
      expect(response).to have_http_status :created
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['role']).to eql USER_ROLE_USER
    end
  end

  describe 'PUT #update' do
    it 'should return success for correct data' do
      user = sign_in_user
      name = user.name + 'new name'

      put :update, params: {id: user.id, display_name: name}
      expect(response).to have_http_status :success

      user.reload
      expect(user.display_name).to eql name
    end

    it 'should not allow to edit another account for not admin role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      new_user = create :user

      put :update, params: {id: new_user.id, display_name: 'new name'}
      expect(response).to have_http_status :forbidden
    end

    it 'should allow to edit another account for admin role' do
      user = sign_in_user
      user.role = USER_ROLE_ADMIN
      user.save

      new_user = create :user

      put :update, params: {id: new_user.id, display_name: 'new name'}
      expect(response).to have_http_status :success
    end

    it 'should not allow to edit all parameters for not admin role' do
      user = sign_in_user
      user.role = USER_ROLE_USER
      user.save

      old_name = user.name
      old_email = user.email
      old_terms_accepted = user.terms_accepted
      put :update, params: {id: user.id, name: 'new name', email: 'new email', terms_accepted: !user.terms_accepted}
      expect(response).to have_http_status :success

      user.reload

      expect(old_name).to eql user.name
      expect(old_email).to eql user.email
      expect(old_terms_accepted).to eql user.terms_accepted
    end

    it 'should allow all parameters for admin role' do
      user = sign_in_user
      user.role = USER_ROLE_ADMIN
      user.save

      old_name = user.name
      old_email = user.email
      put :update, params: {id: user.id, name: 'new name', email: 'email@email.com'}

      user.reload

      expect(old_name).to_not eql user.name
      expect(old_email).to_not eql user.email
    end

    it 'should not allow to update data for not authorized user' do
      user = create :user
      name = user.name + 'new name'

      put :update, params: {id: user.id, display_name: name}
      expect(response).to have_http_status :unauthorized

      user.reload
      expect(user.display_name).to_not eql name
    end
  end
end
