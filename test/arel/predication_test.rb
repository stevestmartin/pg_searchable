require_relative '../test_helper'

describe "Text Predications" do
  describe "tgrm" do
    it "converts Arel tgrm similarity statement" do
      table = Arel::Table.new :articles
      table[:title].tgrm("query").to_sql.must_be_like %{"articles"."title" % 'query'}
    end
  end
end
