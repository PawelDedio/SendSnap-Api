require 'rails_helper'

RSpec.describe UserDevicesController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      should route(:post, 'user_devices').to(action: :create)
    }
  end

  describe 'post #create' do
    it 'should create device with correct data for user role' do
      user = sign_in_user

      device = build :android_device

      post :create, params: device.attributes

      expect(response).to have_http_status :success
    end

    it 'should not allow to create with incorrect data' do
      user = sign_in_user

      device = build :android_device
      device.device_id = nil

      post :create, params: device.attributes

      expect(response).to have_http_status :bad_request
    end

    it 'should not allow for unauthorized user' do
      device = build :android_device

      post :create, params: device.attributes

      expect(response).to have_http_status :unauthorized
    end

    it 'should assign to current user' do
      user = sign_in_user

      device = build :android_device

      post :create, params: device.attributes

      expect(user.user_devices.count).to eql 1
    end
  end
end
