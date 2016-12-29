class SnapsController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'FriendInvitation', except: :create

  def create
    @snap = Snap.new create_params

    if @snap.save
      render status: :created, json: @snap
    else
      render status: :bad_request, json: @snap.errors
    end
  end


  private
  def create_params
    params.permit(:snap_file)
  end
end
