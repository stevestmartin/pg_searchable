require_relative 'test_helper'

describe PgSearchable do
  it "must be defined" do
    PgSearchable::VERSION.wont_be_nil
  end
end
