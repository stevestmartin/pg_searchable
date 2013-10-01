require 'arel/nodes/infix_operation'

module Arel
  module Nodes
    class Dmetaphone < Arel::Nodes::InfixOperation
      def initialize(attribute, query, dictionary)
        relation  = attribute.relation
        columns   = relation.engine.connection.columns_hash(relation.name)
        left      = case columns[attribute.name.to_s].type
        when :tsvector
          attribute
        else
          Arel::Nodes::ToTsvector.new(attribute, dictionary)
        end

        super(:'@@', left, Arel::Nodes::ToTsquery.new(query, dictionary))
      end
    end
  end
end
