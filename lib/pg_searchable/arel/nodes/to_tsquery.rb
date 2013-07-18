require 'arel/nodes/named_function'

module Arel
  module Nodes
    class ToTsquery < Arel::Nodes::NamedFunction
      def initialize(query, dictionary = 'simple')
        super(:to_tsquery, [dictionary, query])
      end
    end
  end
end
