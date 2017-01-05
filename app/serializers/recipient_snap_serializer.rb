class RecipientSnapSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :file,
             :file_type,
             :duration,
             :view_count,
             :created_at,
             :updated_at

  def view_count
    self.object.view_count current_user.id
  end
end