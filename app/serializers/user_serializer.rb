class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :display_name,
             :email,
             :terms_accepted,
             :role,
             :created_at,
             :updated_at
end