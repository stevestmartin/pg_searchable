require 'arel/nodes/infix_operation'

module Arel
  module Nodes
    class Tsearch < Arel::Nodes::InfixOperation
      def initialize(attribute, query, dictionary)
        relation  = attribute.relation
        columns   = relation.engine.connection.columns(relation.name)
        left      = case columns.find {|c| c.name == attribute.name.to_s }.type
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
