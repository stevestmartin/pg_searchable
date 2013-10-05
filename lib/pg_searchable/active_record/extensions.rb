require 'active_record'
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
          pg_searchable_configs[name.to_sym] = {
            tgrm:       _pg_searchable_options,
            dmetaphone: _pg_searchable_options,
            tsearch:    _pg_searchable_options
          }.deep_merge(options)
        end

        def pg_searchable_configs
          @pg_searchable_configs ||= {}
        end

        def search_for(term, options = {})
          scoped.search_for(term, options)
        end

        def close_to(longitude, latitude, distance_in_miles = 5)
          scoped.close_to(longitude, latitude, distance_in_miles)
        end

      private
        def _pg_searchable_options
          @_pg_searchable_options ||= DEFAULT_OPTIONS.merge(columns: _pg_searchable_columns)
        end

        def _pg_searchable_columns
          @_pg_searchable_columns ||= columns_hash.find_all {|k,v| [:string, :text].include?(v.type) }.map {|k,v| v.name }
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, PgSearchable::ActiveRecord::Extensions)
