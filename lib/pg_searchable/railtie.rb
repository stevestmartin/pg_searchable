module PgSearchable
  class Railtie < Rails::Railtie
    generators do
      require 'pg_searchable/migrations/dmetaphone_generator'
    end
  end
end
