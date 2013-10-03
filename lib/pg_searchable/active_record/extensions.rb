require 'active_record/base'
require 'active_support/concern'

module PgSearchable
  module ActiveRecord
    module Extensions
      extend ActiveSupport::Concern

      DEFAULT_COLUMNS     = []
      DEFAULT_WEIGHTS     = [0.1, 0.2, 0.4, 1.0]
      DEFAULT_DICTIONARY  = 'english'
      DEFAULT_OPTIONS     = { columns: DEFAULT_COLUMNS, weights: DEFAULT_WEIGHTS, dictionary: DEFAULT_DICTIONARY }

      module ClassMethods
        def pg_searchable (name, options)
          @_pg_searchable ||= {}
          @_pg_searchable[name.to_sym] = {
            tgrm:       DEFAULT_OPTIONS,
            dmetaphone: DEFAULT_OPTIONS,
            tsearch:    DEFAULT_OPTIONS
          }.deep_merge(options)
        end

        def search_for(term, options = {})
          scoped.search_for(term, options)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, PgSearchable::ActiveRecord::Extensions)
