class SnapForCollectionSerializer < ActiveModel::Serializer

  def initialize(object, options = {})
    if(object.user_id.eql? options[:current_user_id])
      @child_serializer = AuthorSnapSerializer.new object, options
    else
      @child_serializer = RecipientSnapSerializer.new object, options
    end

    super
  end

  def attributes(requested_attrs = nil, reload = false)
    @child_serializer.attributes(requested_attrs, reload)
  end
end