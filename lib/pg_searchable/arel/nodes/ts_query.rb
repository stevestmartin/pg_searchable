require 'arel/nodes/infix_operation'

module Arel
  module Nodes
    class TsQuery < Arel::Nodes::InfixOperation
      def initialize(attribute, query, dictionary)
        relation  = attribute.relation
        columns   = relation.engine.connection.columns_hash(relation.name)
        left      = case columns[attribute.name.to_s].type
        when :tsvector
          attribute
        else
          Arel::Nodes::NamedFunction.new(:to_tsvector, [attribute])
        end

        super(:'@@', left, Arel::Nodes::NamedFunction.new(:to_tsquery, [dictionary, query]))
      end
    end
  end
end
