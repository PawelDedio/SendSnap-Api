require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      should route(:post, 'session/create').to(action: :create)
    }
    it {
      should route(:delete, 'session/destroy').to(action: :destroy)
    }
  end

  describe 'POST #create' do
    it 'should return user after login via email' do
      user = build :user
      password = user.password
      user.save

      params = {email: user.email, password: password}

      post :create, params: params
      expect(response).to have_http_status :ok

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eql user.id
    end

    it 'should return user after login via name' do
      user = build :user
      password = user.password
      user.save

      params = {name: user.name, password: password}

      post :create, params: params
      expect(response).to have_http_status :ok

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eql user.id
    end

    it 'should not authorize with incorrect password' do
      user = build :user
      password = user.password + 'wrongpassword'
      user.save

      params = {email: user.email, password: password}

      post :create, params: params
      expect(response).to have_http_status :unauthorized
    end

    it 'should not authorize with blank data' do
      params = {email: nil, password: nil}

      post :create, params: params
      expect(response).to have_http_status :unauthorized
    end
  end

  describe 'DELETE #destroy' do
    it 'should log out current logged user' do
      sign_in_user

      delete :destroy

      expect(response).to have_http_status :ok
    end

    it 'should return unauthorized for not logged user' do
      delete :destroy

      expect(response).to have_http_status :unauthorized
    end

    it 'should delete all user devices' do
      user = sign_in_user

      device = build :android_device
      device.user_id = user.id
      device.save

      expect(user.user_devices.count).to eql 1

      delete :destroy

      user.reload
      expect(user.user_devices.count).to eql 0
    end
  end
end
