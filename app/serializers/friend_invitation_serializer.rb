class FriendInvitationSerializer < ActiveModel::Serializer
  attributes :id,
             :author_id,
             :recipient_id,
             :accepted_at,
             :rejected_at,
             :created_at,
             :updated_at
end
