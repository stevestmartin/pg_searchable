module Arel
  module Predications
    def similarity(text)
      Nodes::Similarity.new(self, text)
    end
  end
end
