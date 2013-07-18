require 'arel/nodes/named_function'

module Arel
    module Nodes
      class ToTsvector < Arel::Nodes::NamedFunction
        def initialize(query, dictionary = 'simple')
          super(:to_tsvector, [dictionary, query])
        end
      end
    end
end
