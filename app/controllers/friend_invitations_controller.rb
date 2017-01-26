class FriendInvitationsController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'FriendInvitation', except: :create

  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: FriendInvitation)
    collection = search_collection(@friend_invitations, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: FriendInvitationSerializer,
           count: collection.size,
           page: page,
           page_size: page_size
  end

  def from_me
    @friend_invitations = FriendInvitation.accessible_by current_ability
    @friend_invitations = @friend_invitations.where(author_id: current_user.id)

    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: FriendInvitation)
    collection = search_collection(@friend_invitations, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: FriendInvitationSerializer,
           count: collection.size,
           page: page,
           page_size: page_size
  end

  def to_me
    @friend_invitations = FriendInvitation.accessible_by current_ability
    @friend_invitations = @friend_invitations.where(recipient_id: current_user.id)

    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: FriendInvitation)
    collection = search_collection(@friend_invitations, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: FriendInvitationSerializer,
           count: collection.size,
           page: page,
           page_size: page_size
  end

  def create
    @friend_invitation = FriendInvitation.new create_params
    @friend_invitation.author_id = current_user.id
    if @friend_invitation.save
      render json: @friend_invitation,
             serializer: FriendInvitationSerializer,
             status: :created
    else
      render json: @friend_invitation.errors,
             status: :bad_request
    end
  end

  def accept
    ActiveRecord::Base.transaction do
      res = @friend_invitation.accept
      author = @friend_invitation.author
      author.friends << @friend_invitation.recipient
      res &= author.save

      if res
        render status: :no_content
      else
        render json: @friend_invitation.errors,
               status: :bad_request

        raise ActiveRecord::Rollback
      end
    end

  end

  def reject
    if @friend_invitation.reject
      render status: :no_content
    else
      render json: @friend_invitation.errors,
             status: :bad_request
    end
  end

  def cancel
    if @friend_invitation.cancel
      render status: :no_content
    else
      render json: @friend_invitation.errors,
             status: :bad_request
    end
  end


  private
  def create_params
    params.permit(:recipient_id)
  end
end
