module PaginationHelper extend ActiveSupport::Concern

  attr_reader :page, :page_size

  def setup_pagination(options = {})
    @page = options[:page].try(:to_i)
    @page_size = options[:page_size].try(:to_i)
    @page = 1 if @page.nil? || @page < 0
    @page_size = DEFAULT_PAGE_SIZE unless @page_size.in?(MINIMUM_PAGE_SIZE..MAXIMUM_PAGE_SIZE)
  end
end