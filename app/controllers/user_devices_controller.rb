class UserDevicesController < ApplicationController
  before_action :authenticate_user

=begin
  @api {post} /user_devices Register device
  @apiName postUserDevices
  @apiGroup user device
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse UserDeviceCreateParams
  @apiUse SuccessNoContent
  @apiUse ErrorUnauthorized
  @apiUse ErrorBadParams
=end
  def create
    @user_device = create_device

    if @user_device.save
      render status: :no_content
    else
      render status: :bad_request, json: @user_device.errors
    end
  end


  private
=begin
  @apiDefine UserDeviceCreateParams
  @apiParam {string} registration_id given from push library
  @apiParam {string=android} device_type Type of device
  @apiParam {string} device_id Unique phone id
=end
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
