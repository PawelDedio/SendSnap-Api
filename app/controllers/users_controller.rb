class UsersController < ApplicationController
  before_action :authenticate_user, except: :create
  load_and_authorize_resource class: 'User', except: :create

=begin
  @api {get} /users Get users list
  @apiName getUsers
  @apiGroup user
  @apiPermission admin
  @apiUse AuthorizationHeaders
  @apiUse CollectionParams
  @apiUse UserList
  @apiUse ErrorUnauthorized
=end
  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: User)
    collection = @users.page(@page).per(@per_page)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: UserSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end

=begin
  @api {get} /users/:id Get user details
  @apiName getUsersId
  @apiGroup user
  @apiPermission user
  @apiParam {uuid} id User id
  @apiUse AuthorizationHeaders
  @apiUse User
  @apiUse ErrorUnauthorized
=end
  def show
    render json: @user,
           serializer: UserSerializer
  end

=begin
  @api {post} /users Create user account
  @apiName postUsers
  @apiGroup user
  @apiPermission user
  @apiUse UserCreateParams
  @apiUse UserForSession
  @apiUse ErrorBadParams
=end
  def create
    @user = User.new create_params

    if @user.save
      render json: @user,
             serializer: UserForSessionSerializer,
             status: :created
    else
      render json: @user.errors,
             status: :bad_request
    end
  end

=begin
  @api {put} /users/:id Update user account
  @apiName putUsersId
  @apiGroup user
  @apiPermission user
  @apiUse UserUpdateParams
  @apiUse AuthorizationHeaders
  @apiUse User
  @apiUse ErrorBadParams
  @apiUse ErrorUnauthorized
=end
  def update
    @user.assign_attributes update_params

    if @user.save
      render json: @user,
             serializer: UserSerializer,
             status: :ok
    else
      render json: @user.errors,
             status: :bad_request
    end
  end

=begin
  @api {delete} /users/:id Delete user account
  @apiName deleteUsersId
  @apiGroup user
  @apiPermission admin
  @apiParam {uuid} id User id
  @apiUse AuthorizationHeaders
  @apiUse SuccessNoContent
  @apiUse ErrorBadParams
  @apiUse ErrorUnauthorized
=end
  def destroy
    if @user.safe_delete
      render status: :no_content
    else
      render status: :bad_request,
             json: @user.errors
    end
  end

=begin
  @api {put} /users/:id/block Block user account
  @apiName putUsersIdBlock
  @apiGroup user
  @apiPermission admin
  @apiParam {uuid} id User id
  @apiUse AuthorizationHeaders
  @apiUse SuccessNoContent
  @apiUse ErrorBadParams
  @apiUse ErrorUnauthorized
=end
  def block
    if @user.block
      render status: :no_content
    else
      render status: :bad_request,
             json: @user.errors
    end
  end


=begin
  @apiDefine UserCreateParams
  @apiParam {uuid} id User id
  @apiParam {string{3..15}} name User name
  @apiParam {string{3..30}} [display_name] User display name
  @apiParam {string} email User email
  @apiParam {boolean} terms_accepted If user accepted terms and conditions
  @apiParam {string} password User password
  @apiParam {string} password_confirmation User password confirmation
=end
  private
  def create_params
    params.permit(:name, :display_name, :email, :terms_accepted, :password, :password_confirmation)
  end

=begin
  @apiDefine UserUpdateParams
  @apiParam {string{3..15}} name User name, only for admin role
  @apiParam {string{3..30}} [display_name] User display name
  @apiParam {string} email User email, only for admin role
  @apiParam {boolean} terms_accepted If user accepted terms and conditions, only for admin role
=end
  def update_params
    update_params = params.permit(:display_name) if current_user.role.eql? USER_ROLE_USER
    update_params = params.permit(:name, :display_name, :email, :terms_accepted) if current_user.role.eql? USER_ROLE_ADMIN

    update_params
  end
end
