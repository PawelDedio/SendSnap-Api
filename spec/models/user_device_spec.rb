require 'rails_helper'

RSpec.describe UserDevice, type: :model do
  it 'android device should pass validation with correct data' do
    device = build :android_device
    val = device.save

    expect(val).to be true
  end

  describe 'validate user_id' do
    it 'should validate presence' do
      should validate_presence_of(:user_id)
    end
  end

  describe 'validate registration_id' do
    it 'should validate presence' do
      should validate_presence_of(:registration_id)
    end
  end

  describe 'validate device_type' do
    it 'should validate presence' do
      should validate_presence_of(:device_type)
    end

    it 'should not allow invalid value' do
      device = build :android_device
      device.device_type = 'wrongtype'
      val = device.save

      expect(val).to be false
    end
  end

  describe 'validate device_id' do
    it 'should validate presence' do
      should validate_presence_of(:device_id)
    end

    it 'should validate uniqueness' do
      create :android_device
      should validate_uniqueness_of(:device_id).scoped_to(:user_id).case_insensitive
    end
  end
end
