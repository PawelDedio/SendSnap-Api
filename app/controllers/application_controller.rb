class ApplicationController < ActionController::API
  include ActionController::Serialization
  include CanCan::ControllerAdditions
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include SortingHelper
  include PaginationHelper
  include SearchHelper

  def authenticate_user
    authenticate_or_request_with_http_token do |token, options|
      tmp_user = User.find_by_auth_token token

      if tmp_user.present? && tmp_user.token_expire_time.present? && tmp_user.token_expire_time > Time.now
        tmp_user.extend_token_time
        @current_user = tmp_user
      else
        render status: :unauthorized
        return
      end
    end
  end

  def current_user
    @current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    render status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    render status: :not_found
  end
end
