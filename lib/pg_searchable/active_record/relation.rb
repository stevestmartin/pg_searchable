require 'active_record/relation'

module PgSearchable
  module ActiveRecord
    module Relation
      def search_for(term, options = {})
        using       = Array(options.delete(:using) || :default)
        models      = Array(options[:in]).map {|association| klass.reflect_on_association(association).klass }
        conditions  = []
        orders      = []

        [self.klass, models].flatten.each do |klass|
          name    = using.find {|name| klass.pg_searchable_configs.key?(name.to_sym) }
          config  = klass.pg_searchable_configs[name]

          Array(config[:tsearch][:columns]).each do |name|
            conditions << klass.arel_table[name].tsearch(term, config[:tsearch][:dictionary]).to_sql
            orders      << "ts_rank_cd(ARRAY[#{config[:tsearch][:weights][0]}, #{config[:tsearch][:weights][1]}, #{config[:tsearch][:weights][2]}, #{config[:tsearch][:weights][3]}], #{arel_table.name}.#{name}, to_tsquery('#{config[:tsearch][:dictionary]}', '#{term}'), #{config[:tsearch][:normalization]})"
          end

          Array(config[:tgrm][:columns]).each do |name|
            conditions  << klass.arel_table[name].tgrm(term).to_sql
            orders      << "(coalesce(similarity(#{klass.arel_table.name}.#{name}, '#{term}'), 0) / 4)"
          end

          Array(config[:dmetaphone][:columns]).each do |name|
            conditions  << klass.arel_table[name].dmetaphone(term, config[:dmetaphone][:dictionary]).to_sql
            orders      << "(ts_rank_cd(ARRAY[#{config[:dmetaphone][:weights][0]}, #{config[:dmetaphone][:weights][1]}, #{config[:dmetaphone][:weights][2]}, #{config[:dmetaphone][:weights][3]}], #{arel_table.name}.#{name}, to_tsquery('#{config[:dmetaphone][:dictionary]}', pg_searchable_dmetaphone('#{term}')), #{config[:dmetaphone][:normalization]}) / 2)"
          end
        end

        where("#{conditions.join(' OR ')}")#.order("#{orders.join(' + ')} DESC")
      end

      def close_to(longitude, latitude, distance_in_miles = 5)
        distance_in_meters  = (distance_in_miles.to_f * 1609.34).ceil
        longitude_column    = "longitude"
        latitude_column     = "latitude"

        where("ST_DWithin(
            ST_GeographyFromText('SRID=4326;POINT(' || #{arel_table.name}.#{longitude_column} || ' ' || #{arel_table.name}.#{latitude_column} || ')'),
            ST_GeographyFromText('SRID=4326;POINT(%f %f)'), %d
          )", longitude, latitude, distance_in_meters)
        .order("ST_Distance(
          ST_GeographyFromText('SRID=4326;POINT(' || #{arel_table.name}.#{longitude_column} || ' ' || #{arel_table.name}.#{latitude_column} || ')'),
          ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')
        )")
      end
    end
  end
end

ActiveRecord::Relation.send(:include, PgSearchable::ActiveRecord::Relation)
