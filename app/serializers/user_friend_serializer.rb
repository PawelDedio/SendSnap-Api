class UserFriendSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :display_name
end