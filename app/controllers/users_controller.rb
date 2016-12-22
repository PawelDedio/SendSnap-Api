class UsersController < ApplicationController
  before_action :authenticate_user, except: :create
  load_and_authorize_resource class: 'User', except: :create

  def index
    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order])
    collection = search_collection(@users, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: UserSerializer,
           count: collection.size,
           page: page,
           page_size: page_size
  end

  def show
    render json: @user,
           serializer: UserSerializer
  end

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


  private
  def create_params
    params.permit(:name, :display_name, :email, :terms_accepted, :password, :password_confirmation)
  end

  def update_params
    update_params = params.permit(:display_name) if current_user.role.eql? USER_ROLE_USER
    update_params = params.permit(:name, :display_name, :email, :terms_accepted) if current_user.role.eql? USER_ROLE_ADMIN

    update_params
  end
end
