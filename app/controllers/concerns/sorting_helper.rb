module SortingHelper extend ActiveSupport::Concern

  def setup_sorting(options = {})
    sort_by = options[:sort_by].try(:to_sym)
    order = options[:order].try(:to_sym)

    sort_by = DEFAULT_SORT_BY if sort_by.nil?
    order = DEFAULT_SORT_ORDER if order.nil?

    unless sort_params_valid?(options[:model], sort_by, order)
      @sort_by = sort_by
      @order = order
    end
  end

  def sort_params_valid?(model, sort_by, order)
    value = true
    value &= model.has_attribute? sort_by
    value && order.in?(%i(asc desc))
  end
end