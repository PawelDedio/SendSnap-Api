class UserDevicesController < ApplicationController
  before_action :authenticate_user

  def create
    @user_device = UserDevice.new create_params
    @user_device.user = current_user

    if @user_device.save
      render status: :no_content
    else
      render status: :bad_request, json: @user_device.errors
    end
  end


  private
  def create_params
    params.permit(:registration_id, :device_type, :device_id)
  end
end
