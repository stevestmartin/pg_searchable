module Arel
  module Nodes
    class Similarity < Arel::Nodes::InfixOperation
      def initialize(left, right)
        super(:%, left, right)
      end
    end
  end
end
