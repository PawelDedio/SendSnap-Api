class UsersController < ApplicationController
  before_action :authenticate_user, except: :create
  load_and_authorize_resource class: 'User', except: :create

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


  private
  def create_params
    params.permit(:name, :display_name, :email, :terms_accepted, :password, :password_confirmation)
  end
end
