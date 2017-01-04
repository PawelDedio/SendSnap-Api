class AuthorSnapSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :file,
             :file_type,
             :duration,
             :created_at,
             :recipients,
             :updated_at

  def recipients
    ActiveModelSerializers::SerializableResource.new(self.object.recipients, each_serializer: UserSerializer).to_json
  end
end