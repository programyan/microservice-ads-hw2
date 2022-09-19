require_relative '../base_service'
require 'grape-route-helpers'

module Ads
  class FetchRecords
    prepend BaseService

    option :params
    option :path
    option :page, default: proc { 1 }

    attr_reader :ads, :links

    def call
      @ads = Ad.reverse(:updated_at).paginate(page, 10)
      @links = generate_links.compact
    end

    private

    def generate_links
      return {} if @ads.pagination_record_count.zero?

      {
        first: link_to(1),
        last: link_to(@ads.page_count),
        prev: link_to(@ads.prev_page),
        next: link_to(@ads.next_page)
      }
    end

    def link_to(number)
      return unless number

      [path, params.merge('page' => number).map {|k,v| "#{k}=#{v}" }.join('&')].join('?')
    end
  end
end