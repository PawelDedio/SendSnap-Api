class FriendsController < ApplicationController
  before_action :authenticate_user

=begin
  @api {get} /friends Get user friends
  @apiName getFriends
  @apiGroup friend
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse CollectionParams
  @apiUse FriendList
  @apiUse ErrorUnauthorized
=end
  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: User)
    collection = current_user.all_friends.page(@page).per(@per_page)
    collection = collection.order(@sort_by => @sort_order)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: UserFriendSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end

=begin
  @api {delete} /friends/:id Delete user friend
  @apiName deleteFriendsId
  @apiGroup friend
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse SuccessNoContent
  @apiUse ErrorBadRequest
  @apiUse ErrorUnauthorized
=end
  def destroy
    friend = User.find_by_id(params[:id])

    if current_user.all_friends.include?(friend)
      current_user.friends.delete(friend)
      friend.friends.delete(current_user)

      render status: :no_content
    else
      render status: :bad_request
    end
  end
end
