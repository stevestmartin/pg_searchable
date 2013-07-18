require 'arel/nodes/infix_operation'

module Arel
  module Nodes
    class Tgrm < Arel::Nodes::InfixOperation
      def initialize(left, right)
        super(:%, left, right)
      end
    end
  end
end
