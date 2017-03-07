class FriendInvitationsController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'FriendInvitation', except: :create

=begin
  @api {get} /friend_invitations Get all invitations
  @apiDescription This method gives all invitations from all users
  @apiName getFriendInvitations
  @apiGroup friend invitations
  @apiPermission admin
  @apiUse AuthorizationHeaders
  @apiUse CollectionParams
  @apiUse FriendInvitationList
  @apiUse ErrorUnauthorized
=end
  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: FriendInvitation)
    collection = @friend_invitations.page(@page).per(@per_page)
    collection = collection.order(@sort_by => @sort_order)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: FriendInvitationSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end

=begin
  @api {get} /friend_invitations/from_me Get invitations where user is author
  @apiName getFriendInvitationsFromMe
  @apiGroup friend invitations
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse CollectionParams
  @apiUse FriendInvitationList
  @apiUse ErrorUnauthorized
=end
  def from_me
    @friend_invitations = @friend_invitations.where(author_id: current_user.id)

    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: FriendInvitation)
    collection = @friend_invitations.page(@page).per(@per_page)
    collection = collection.order(@sort_by => @sort_order)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: FriendInvitationSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end

=begin
  @api {get} /friend_invitations/to_me Get invitations where user is recipient
  @apiName getFriendInvitationsFromMe
  @apiGroup friend invitations
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse CollectionParams
  @apiUse FriendInvitationList
  @apiUse ErrorUnauthorized
=end
  def to_me
    @friend_invitations = @friend_invitations.where(recipient_id: current_user.id)

    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: FriendInvitation)
    collection = @friend_invitations.page(@page).per(@per_page)
    collection = collection.order(@sort_by => @sort_order)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: FriendInvitationSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end

=begin
  @api {post} /friend_invitations/ Create friend invitation
  @apiName postFriendInvitations
  @apiGroup friend invitations
  @apiPermission user
  @apiUse FriendInvitationsCreateParams
  @apiUse AuthorizationHeaders
  @apiUse FriendInvitation
  @apiUse ErrorUnauthorized
=end
  def create
    @friend_invitation = FriendInvitation.new create_params
    @friend_invitation.author_id = current_user.id
    if @friend_invitation.save
      render json: @friend_invitation,
             serializer: FriendInvitationSerializer,
             status: :created
      FriendInvitationNotifications.notification_received(@friend_invitation.author, @friend_invitation.recipient)
    else
      render json: @friend_invitation.errors,
             status: :bad_request
    end
  end

=begin
  @api {put} /friend_invitations/:id/accept Accept friend invitations
  @apiDescription Only invitation recipient can use this method
  @apiName putFriendInvitationsIdAccept
  @apiGroup friend invitations
  @apiPermission user
  @apiParam {uuid} id Friend Invitation id
  @apiUse AuthorizationHeaders
  @apiUse SuccessNoContent
  @apiUse ErrorBadRequest
  @apiUse ErrorUnauthorized
=end
  def accept
    ActiveRecord::Base.transaction do
      res = @friend_invitation.accept
      author = @friend_invitation.author
      author.friends << @friend_invitation.recipient
      res &= author.save

      if res
        render status: :no_content
        FriendInvitationNotifications.invitation_accepted(@friend_invitation.author, @friend_invitation.recipient)
      else
        render json: @friend_invitation.errors,
               status: :bad_request

        raise ActiveRecord::Rollback
      end
    end

  end

=begin
  @api {put} /friend_invitations/:id/reject Reject friend invitations
  @apiDescription Only invitation recipient can use this method
  @apiName putFriendInvitationsIdReject
  @apiGroup friend invitations
  @apiPermission user
  @apiParam {uuid} id Friend Invitation id
  @apiUse AuthorizationHeaders
  @apiUse SuccessNoContent
  @apiUse ErrorBadRequest
  @apiUse ErrorUnauthorized
=end
  def reject
    if @friend_invitation.reject
      render status: :no_content
      FriendInvitationNotifications.invitation_rejected(@friend_invitation.author, @friend_invitation.recipient)
    else
      render json: @friend_invitation.errors,
             status: :bad_request
    end
  end

=begin
  @api {delete} /friend_invitations/:id/cancel Cancel friend invitations
  @apiDescription Only invitation author can use this method
  @apiName deleteFriendInvitationsIdCancel
  @apiGroup friend invitations
  @apiPermission user
  @apiParam {uuid} id Friend Invitation id
  @apiUse AuthorizationHeaders
  @apiUse SuccessNoContent
  @apiUse ErrorBadRequest
  @apiUse ErrorUnauthorized
=end
  def cancel
    if @friend_invitation.cancel
      render status: :no_content
    else
      render json: @friend_invitation.errors,
             status: :bad_request
    end
  end


=begin
  @apiDefine FriendInvitationsCreateParams
  @apiParam {uuid} recipient_id Recipient id
=end
  private
  def create_params
    params.permit(:recipient_id)
  end
end
