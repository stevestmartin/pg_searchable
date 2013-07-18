require 'arel/predications'

module Arel
  module Predications
    def tgrm(text)
      Nodes::Tgrm.new(self, text)
    end

    def tsearch(text, dictionary = 'simple')
      Nodes::Tsearch.new(self, text, dictionary)
    end

    def dmetaphone(text, dictionary = 'simple')
      Nodes::Dmetaphone.new(self, text, dictionary)
    end
  end
end
