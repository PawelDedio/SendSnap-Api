module SortingHelper extend ActiveSupport::Concern

  def setup_sorting(options = {})
    @sort_by = options[:sort_by].try(:to_sym)
    @order = options[:order].try(:to_sym)
    @sort_by = DEFAULT_SORT_BY if @sort_by.nil?
    @order = DEFAULT_SORT_ORDER if @order.nil?
  end

  def sort_params_valid?(model)
    value = true
    value &= model.has_attribute? @sort_by
    value && @order.in?(%i(asc desc))
  end
end