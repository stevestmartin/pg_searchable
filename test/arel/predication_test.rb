require_relative '../test_helper'

describe "text search predications" do
  describe "tgrm" do
    it "should compare using tgrm operator" do
      table = Arel::Table.new :articles
      table[:title].tgrm("query").to_sql.must_be_like %{"articles"."title" % 'query'}
    end
  end

  describe "tsearch" do
    it "should compare column as tsvector when a string" do
      table = Arel::Table.new :articles
      table[:title].tsearch("query", "dictionary").to_sql.must_be_like %{to_tsvector("articles"."title") @@ to_tsquery('dictionary', 'query')}
    end

    it "should compare column as is when a tsvector" do
      table = Arel::Table.new :articles
      table[:tsvector].tsearch("query", "dictionary").to_sql.must_be_like %{"articles"."tsvector" @@ to_tsquery('dictionary', 'query')}
    end
  end

  describe "dmetaphone" do
    # it "should compare using dmetaphone function" do
    #   table = Arel::Table.new :articles
    #   table[:title].dmetaphone("query").to_sql.must_be_like %{"articles"."title" % 'query'}
    # end
  end
end
