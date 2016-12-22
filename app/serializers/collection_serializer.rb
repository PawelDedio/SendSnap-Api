class CollectionSerializer < ActiveModel::ArraySerializer

  root :collection

  attr_reader :count, :page, :per_page

  def initialize(object, options = {})
    @count = options[:count]
    @page = options[:page]
    @per_page = options[:per_page]
    super
  end

  def as_json(options = {})
    collection_options.merge!(super)
  end

  private

  def collection_options
    {count: count, page: page, per_page: per_page}.compact
  end
end