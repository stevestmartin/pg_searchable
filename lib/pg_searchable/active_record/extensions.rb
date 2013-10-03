require 'active_record/base'
require 'active_support/concern'

module PgSearchable
  module ActiveRecord
    module Extensions
      extend ActiveSupport::Concern

      DEFAULT_WEIGHTS     = [0.1, 0.2, 0.4, 1.0]
      DEFAULT_DICTIONARY  = 'english'
      DEFAULT_OPTIONS     = { weights: DEFAULT_WEIGHTS, dictionary: DEFAULT_DICTIONARY }

      module ClassMethods
        def pg_searchable (name, options = {})
          # precompute data for subsequent calls
          @_pg_searchable ||= {}
          @_pg_searchable_columns ||= columns_hash.find_all {|k,v| [:string, :text].include?(v.type) }.map {|k,v| v.name}
          @_pg_searchable_options ||= DEFAULT_OPTIONS.merge(columns: @_pg_searchable_columns)

          # set configuration for current call
          @_pg_searchable[name.to_sym] = {
            tgrm:       @_pg_searchable_options,
            dmetaphone: @_pg_searchable_options,
            tsearch:    @_pg_searchable_options
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
