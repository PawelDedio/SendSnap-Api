module SearchHelper extend ActiveSupport::Concern

  attr_reader :search_field, :search_value

  def search_collection(collection, options = {})
    @search_field = options[:search_field]
    @search_value = options[:search_value]

    collection = collection.where(@search_field => @search_value) if search_params_valid? collection
    collection
  end

  def search_params_valid?(collection)
    model = collection.first
    value = true
    return false if model.nil?
    value &= model.has_attribute? @search_field
    value && @search_value.present?
  end
end