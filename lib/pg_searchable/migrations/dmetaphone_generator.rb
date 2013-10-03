require 'rails/generators/base'

module PgSearchable
  module Migrations
    class DmetaphoneGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_migration
        now = Time.now.utc
        filename = "#{now.strftime('%Y%m%d%H%M%S')}_add_pg_searchable_dmetaphone_support_function.rb"
        template 'add_pg_searchable_dmetaphone_support_function.rb.erb', "db/migrate/#{filename}"
      end
    end
  end
end
