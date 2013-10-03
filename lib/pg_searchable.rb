require 'pg_searchable/version'
require 'pg_searchable/active_record'
require 'pg_searchable/arel'
require "pg_searchable/railtie" if defined?(Rails)

# TODO:
# 1) add ranking functions for full text search
# 2) write tests for migration helpers
# 3) add support for postgis?
# 4) add Relation methods
