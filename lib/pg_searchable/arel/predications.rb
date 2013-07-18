require 'arel/predications'

module Arel
  module Predications
    def tgrm(text)
      Nodes::Tgrm.new(self, text)
    end

    def ts_query(text, dictionary = 'simple')
      Nodes::TsQuery.new(self, text, dictionary)
    end
  end
end
