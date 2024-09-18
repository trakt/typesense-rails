module Typesense
  module Pagination
    autoload :WillPaginate, 'typesense/pagination/will_paginate'
    autoload :Kaminari, 'typesense/pagination/kaminari'

    def self.create(results, total_hits, options = {})
      return results if Typesense.pagination_backend.nil?

      begin
        # classify pagination backend name
        backend = Typesense.pagination_backend.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        Object.const_get(:Typesense).const_get(:Pagination).const_get(backend).create(results, total_hits, options)
      rescue NameError
        raise(Typesense::Error::MissingConfiguration, 'Unknown pagination backend')
      end
    end
  end
end
