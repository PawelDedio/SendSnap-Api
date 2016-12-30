class SnapsController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'Snap', except: :create

  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order])
    collection = search_collection(@snaps, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: FullSnapSerializer,
           count: collection.size,
           page: page,
           page_size: page_size
  end

  def show
    render json: @snap,
           serializer: show_serializer
  end

  def create
    @snap = Snap.new create_params

    if @snap.save
      render status: :created, json: @snap
    else
      render status: :bad_request, json: @snap.all_errors
    end
  end


  private
  def create_params
    params.permit(:file, :user_id, :file_type, :duration, recipient_ids: [])
  end

  def show_serializer
    if current_user.role.eql? USER_ROLE_ADMIN
      FullSnapSerializer
      return
    end

    if @snap.user_id.eql? current_user.id
      AuthorSnapSerializer
    else
      RecipientSnapSerializer
    end
  end
end
