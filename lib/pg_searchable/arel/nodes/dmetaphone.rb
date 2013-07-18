require 'arel/nodes/infix_operation'

module Arel
  module Nodes
    class Dmetaphone < Arel::Nodes::InfixOperation
      def initialize(attribute, query, dictionary)
        super(:'@@', attribute, Arel::Nodes::NamedFunction.new(:to_tsquery, [dictionary, query]))
      end
    end
  end
end
