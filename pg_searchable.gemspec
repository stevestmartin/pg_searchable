# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_searchable/version'

Gem::Specification.new do |spec|
  spec.name          = "pg_searchable"
  spec.version       = PgSearchable::VERSION
  spec.authors       = ["Stephen St. Martin"]
  spec.email         = ["steve@stevestmartin.com"]
  spec.description   = %q{Simple ActiveRecord PostgreSQL full text backed by Arel}
  spec.summary       = %q{Simple ActiveRecord PostgreSQL full text backed by Arel}
  spec.homepage      = "https://github.com/stevestmartin/pg_searchable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "arel", ">= 3.0.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "minitest", "~> 4.6"
  spec.add_development_dependency "rake"
end
