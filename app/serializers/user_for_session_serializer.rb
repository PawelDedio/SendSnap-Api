class UserForSessionSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :display_name,
             :email,
             :terms_accepted,
             :role,
             :auth_token,
             :token_expire_time,
             :created_at,
             :updated_at
end