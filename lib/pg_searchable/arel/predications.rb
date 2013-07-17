module Arel
  module Predications
    def tgrm(text)
      Nodes::Tgrm.new(self, text)
    end
  end
end
