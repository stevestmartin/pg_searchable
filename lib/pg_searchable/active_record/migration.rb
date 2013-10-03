require 'active_record/migration'

module ActiveRecord
  class Migration
    def add_pg_searchable_tsearch_trigger(table_name, column_name, options = {})
      options.reverse_merge({ dictionary: 'simple', columns: nil })
      column_data           = case options[:columns]
        when Array then "to_tsvector('#{options['dictionary']}', #{options[:columns].map {|column_name| "coalesce(#{column_name}, '')" }.join(" || ' ' || ") });"
        when Hash then "#{options[:columns].map {|column_name, weight| "setweight(to_tsvector('#{options[:dictionary]}', coalesce(#{column_name}, '')), '#{weight}')" }.join(" || ")};"
      end

      _add_pg_searchable_trigger(table_name, column_name, :tsearch, column_data)
    end

    def remove_pg_searchable_tsearch_trigger(table_name, column_name)
      _remove_pg_searchable_trigger(table_name, column_name, :tsearch)
    end

    def add_pg_searchable_dmetaphone_trigger(table_name, column_name, options = {})
      options.reverse_merge({ dictionary: 'simple', columns: nil })
      column_data           = case options[:columns]
        when Array then "to_tsvector('#{options['dictionary']}', #{options[:columns].map {|column_name| "pg_searchable_dmetaphone(coalesce(#{column_name}, ''))" }.join(" || ' ' || ") });"
        when Hash then "#{options[:columns].map {|column_name, weight| "setweight(to_tsvector('#{options[:dictionary]}', pg_searchable_dmetaphone(coalesce(#{column_name}, ''))), '#{weight}')" }.join(" || ")};"
      end

      _add_pg_searchable_trigger(table_name, column_name, :dmetaphone, column_data)
    end

    def remove_pg_searchable_dmetaphone_trigger(table_name, column_name)
      _remove_pg_searchable_trigger(table_name, column_name, :dmetaphone)
    end

    def add_pg_searchable_dictionary(dictionary, options = {})
      remove_pg_searchable_dictionary(dictionary)

      options.reverse_merge({
        catalog:    'english',
        template:   'ispell',
        dict_file:  'english',
        aff_file:   'english',
        stop_words: 'english',
        mappings:   'asciiword, asciihword, hword_asciipart, word, hword, hword_part'
      })

      execute <<-EOS
        CREATE TEXT SEARCH CONFIGURATION #{dictionary} ( COPY = pg_catalog.#{options[:catalog]} );
        CREATE TEXT SEARCH DICTIONARY #{dictionary}_dict (
          TEMPLATE = #{options[:template]},
          DictFile = #{options[:dict_file]},
          AffFile = #{options[:aff_file]},
          StopWords = #{options[:stop_words]}
        );
        ALTER TEXT SEARCH CONFIGURATION #{dictionary}
        ALTER MAPPING FOR #{options[:mappings]}
        WITH unaccent, #{dictionary}_dict, english_stem;

      EOS
    end

    def remove_pg_searchable_dictionary(dictionary)
      execute <<-SQL
        DROP TEXT SEARCH CONFIGURATION IF EXISTS #{dictionary};
        DROP TEXT SEARCH DICTIONARY IF EXISTS #{dictionary}_dict;
      SQL
    end

  private

    def _add_pg_searchable_trigger(table_name, column_name, trigger_type = 'tsearch', column_data = '')
      trigger_name = "#{table_name}_#{column_name}_#{trigger_type}"

      # be sure to remove trigger / function before recreating it
      _remove_pg_searchable_trigger(table_name, column_name, trigger_type)

      execute <<-SQL
        CREATE OR REPLACE FUNCTION #{trigger_name}_update() RETURNS trigger AS $$
        begin
          new.#{column_name} := #{column_data}
          return new;
        end
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER #{trigger_name} BEFORE INSERT OR UPDATE
        ON #{table_name}
        FOR EACH ROW EXECUTE PROCEDURE #{trigger_name}_update();
      SQL
    end

    def _remove_pg_searchable_trigger(table_name, column_name, trigger_type = 'tsearch')
      trigger_name = "#{table_name}_#{column_name}_#{trigger_type}"

      execute <<-SQL
        DROP FUNCTION IF EXISTS #{trigger_name}_update();
        DROP TRIGGER IF EXISTS #{trigger_name} ON #{table_name};
      SQL
    end
  end
end
