class UserDevicesController < ApplicationController
  before_action :authenticate_user

  def create
    @user_device = create_device

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

  def create_device
    device = UserDevice.find_by_device_id(create_params[:device_id])

    if device.nil?
      device = UserDevice.new create_params
    else
      device.registration_id = create_params[:registration_id]
    end
    device.user = current_user
    device
  end
end
