class SnapsController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'Snap', except: :create

=begin
  @api {get} /snaps Get snaps sent and received by user
  @apiName getSnaps
  @apiGroup snap
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse CollectionParams
  @apiUse SnapList
  @apiUse ErrorUnauthorized
=end
  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: Snap)
    collection = all_snaps.page(@page).per(@per_page)
    collection = collection.order(@sort_by => @sort_order)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: SnapForCollectionSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size,
           current_user_id: current_user.id
  end

=begin
  @api {get} /snaps/:id Get snap details
  @apiName getSnapsId
  @apiGroup snap
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiParam {uuid} id Snap id
  @apiUse AuthorSnap
  @apiUse RecipientSnap
  @apiUse ErrorUnauthorized
=end
  def show
    render json: @snap,
           serializer: show_serializer
  end

=begin
  @api {get} /snaps/:id/view View snap
  @apiDescription This method is use to check snap as viewed, this request should be made when user opens snap. Available only for recipient
  @apiName getSnapsIdView
  @apiGroup snap
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiParam {uuid} id Snap id
  @apiUse RecipientSnap
  @apiUse ErrorUnauthorized
  @apiUse ErrorBadRequest
=end
  def view
    if @snap.view current_user.id
      render json: @snap,
             serializer: RecipientSnapSerializer
      SnapNotifications.snap_viewed @snap, current_user
    else
      render status: :bad_request
    end
  end

=begin
  @api {get} /snaps/:id/image Snap Image
  @apiDescription Endpoint for snap file, returns bad_request when view count is more than 0
  @apiName getSnapsIdImage
  @apiGroup snap
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiParam {uuid} id Snap id
  @apiUse AuthorSnap
  @apiUse ErrorUnauthorized
  @apiUse ErrorBadRequest
=end
  def image
    view_count = @snap.view_count current_user.id

    if view_count < 1
      send_file @snap.file.path, type: 'image/png', disposition: 'inline'
    else
      render status: :bad_request
    end
  end

=begin
  @api {post} /snaps Create Snap
  @apiName postSnaps
  @apiGroup snap
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse SnapCreateParams
  @apiUse AuthorSnap
  @apiUse ErrorUnauthorized
  @apiUse ErrorBadParams
=end
  def create
    @snap = Snap.new create_params
    @snap.user = current_user

    if @snap.save
      render status: :created, json: @snap, serializer: AuthorSnapSerializer
      SnapNotifications.snap_received @snap
    else
      render status: :bad_request, json: @snap.all_errors
    end
  end

=begin
  @api {post} /snaps/:id/replay Replay snap
  @apiDescription After this request user can use view again for this snap. Available only once per day for user and only less than hour after snap displaying. Available only for recipient
  @apiName putSnapsIdReplay
  @apiGroup snap
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiParam {uuid} id Snap id
  @apiUse SuccessNoContent
  @apiUse ErrorForbidden
  @apiUse ErrorUnauthorized
=end
  def replay
    if @snap.replay current_user
      render status: :no_content
      SnapNotifications.snap_replayed @snap, current_user
    else
      render status: :forbidden
    end
  end

=begin
  @api {post} /snaps/:id/screenshot Send screenshot info
  @apiDescription Sends info about screenshot for snap, available only for recipient
  @apiName putSnapsIdScreenshot
  @apiGroup snap
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiParam {uuid} id Snap id
  @apiUse SuccessNoContent
  @apiUse ErrorBadRequest
  @apiUse ErrorUnauthorized
=end
  def screenshot
    if @snap.screenshot current_user.id
      render status: :no_content
      SnapNotifications.screenshot_made @snap, current_user
    else
      render status: :bad_request
    end
  end


  private
  def all_snaps
    Snap.eager_load(:recipients).where("user_snaps.user_id = '#{current_user.id}' OR snaps.user_id = '#{current_user.id}'")
  end

=begin
  @apiDefine SnapCreateParams
  @apiParam {file} file Snap file
  @apiParam {string=photo, video} file_type Type of snap
  @apiParam {number} duration Duration of snap (in seconds)
  @apiParam {string[]} recipient_ids List of recipient ids
=end
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
