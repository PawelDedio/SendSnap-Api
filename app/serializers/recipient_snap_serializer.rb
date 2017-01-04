class RecipientSnapSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :file,
             :file_type,
             :duration,
             :created_at,
             :updated_at
end