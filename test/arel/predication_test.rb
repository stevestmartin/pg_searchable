require_relative '../test_helper'

describe "Similarity" do
  it "converts Arel similarity statement" do
    table = Arel::Table.new :articles
    table[:title].similarity("query").to_sql.must_be_like %{"articles"."title" % 'query'}
  end
end
