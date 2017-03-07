class SnapsController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'Snap', except: :create

  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: Snap)
    collection = all_snaps.page(@page).per(@per_page)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: AuthorSnapSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end

  def show
    render json: @snap,
           serializer: show_serializer
  end

  def view
    if @snap.view current_user.id
      render json: @snap,
             serializer: RecipientSnapSerializer
    else
      render status: :bad_request
    end
  end

  def image
    view_count = @snap.view_count current_user.id

    if view_count < 1
      send_file @snap.file.path, type: 'image/png', disposition: 'inline'
    else
      render status: :bad_request
    end
  end

  def create
    @snap = Snap.new create_params
    @snap.user = current_user

    if @snap.save
      render status: :created, json: @snap
    else
      render status: :bad_request, json: @snap.all_errors
    end
  end

  def replay
    if @snap.replay current_user
      render status: :no_content
    else
      render status: :forbidden
    end
  end

  def screenshot
    if @snap.screenshot current_user.id
      render status: :no_content
    else
      render status: :bad_request
    end
  end


  private
  def all_snaps
    Snap.eager_load(:recipients).where("user_snaps.user_id = '#{current_user.id}' OR snaps.user_id = '#{current_user.id}'")
  end
  def create_params
    params.permit(:file, :file_type, :duration, recipient_ids: [])
  end

  def show_serializer
    if @snap.recipient_ids.include? current_user.id
      RecipientSnapSerializer
    else
      AuthorSnapSerializer
    end
  end
end
