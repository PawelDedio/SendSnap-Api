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

      except(response).to have_http_status :success
      except(parsed_response[COLLECTION_LABEL].count).to eql 2
    end

    it 'should not allow access for not admin role' do
      user1 = sign_in_user
      user2 = create :user

      get :index

      except(response).to have_http_status :forbidden
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
      
    end
  end
end
