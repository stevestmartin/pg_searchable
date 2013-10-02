require 'arel/nodes/named_function'

module Arel
  module Nodes
    class PgSearchableDmetaphone < Arel::Nodes::NamedFunction
      def initialize(query)
        super(:pg_searchable_dmetaphone, [query])
      end
    end
  end
end
