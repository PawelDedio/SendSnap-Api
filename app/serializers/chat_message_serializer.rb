class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id,
             :message,
             :author_id,
             :recipient_id,
             :read_at,
             :created_at,
             :updated_at
end