module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = set_user
    end

    private
    def set_user
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
  end
end
