class SessionsController < ApplicationController

  before_action :authenticate_user, only: :destroy

  def create
    email = create_params[:email]
    name = create_params[:name]
    password = create_params[:password]

    if (email.nil? and name.nil?) or password.nil?
      render status: :unauthorized
      return
    end

    user = User.where(name: name).or(User.where(email: email)).first

    if user.present? && user.authenticate(password)
      user.sign_in

      render json: user, serializer: UserForSessionSerializer, status: :ok
    else
      render status: :unauthorized
    end
  end

  def destroy
    if @current_user.nil?
      render status: :unauthorized
    else
      @current_user.sign_out
      render status: :ok
    end
  end


  private
  def create_params
    params.permit(:email, :name, :password)
  end
end
