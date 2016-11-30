require 'rails_helper'

RSpec.describe User, type: :model do

  it 'should pass validation with correct data' do
    user = build :user
    val = user.save

    expect(val).to be true
  end

  describe 'validate name' do
    it 'should validate presence of' do
      should validate_presence_of(:name)
    end

    it 'should allow only longer than minimum' do
      should validate_length_of(:name).is_at_least(USER_NAME_MIN_LENGTH)
    end

    it do 'should allow only less than maximum'
      should validate_length_of(:name).is_at_most(USER_NAME_MAX_LENGTH)
    end

    it 'should validate uniqueness' do
      create :user
      should validate_uniqueness_of(:name)
    end
  end

  describe 'validate display_name' do
    it 'should allow nil value' do
      should allow_value(nil).for(:display_name)
    end

    it 'should allow only longer than minimum' do
      should validate_length_of(:display_name).is_at_least(USER_DISPLAY_NAME_MIN_LENGTH)
    end

    it 'should allow only less than maximum' do
      should validate_length_of(:display_name).is_at_most(USER_DISPLAY_NAME_MAX_LENGTH)
    end
  end

  describe 'validate email' do
    it 'should validate presence of' do
      should validate_presence_of(:email)
    end

    it 'should validate uniqueness' do
      create :user
      should validate_uniqueness_of(:email).case_insensitive
    end

    it 'should not allow wrong email' do
      user = build :user
      user.email = 'wrongemail@'
      res = user.save

      expect(res).to be false
    end
  end

  describe 'validates password' do
    it 'should validate presence of' do
      should validate_presence_of(:password)
    end

    it 'should validate confirmation of' do
      should validate_confirmation_of(:password)
    end
  end

  describe 'validate terms_accepted' do
    it 'should validate presence of' do
      should validate_presence_of(:terms_accepted)
    end

    it 'should allow only true value' do
      user = build :user
      user.terms_accepted = false
      res = user.save

      expect(res).to be false

      user.terms_accepted = true
      res = user.save

      expect(res).to be true
    end
  end

  describe 'validate role' do
    it 'should allow only allowed role' do
      user = build :user
      user.role = USER_ROLE_ADMIN
      res = user.save

      expect(res).to be true

      user.role = USER_ROLE_USER
      res = user.save

      expect(res).to be

      user.role = 'wrong role'
      res = user.save

      expect(res).to be false
    end
  end
end
