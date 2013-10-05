require 'active_record/relation'

module PgSearchable
  module ActiveRecord
    module Relation
      def search_for(term, options = {})
        using       = Array(options.delete(:using) || :default)
        models      = Array(options[:in]).map {|association| klass.reflect_on_association(association).klass }
        conditions  = [self.klass, models].flatten.inject([]) do |conditions, klass|
          name    = using.find {|name| klass.pg_searchable_configs.key?(name.to_sym) }
          config  = klass.pg_searchable_configs[name]

          Array(config[:tgrm][:columns]).each       {|name| conditions << klass.arel_table[name].tgrm(term).to_sql }
          Array(config[:tsearch][:columns]).each    {|name| conditions << klass.arel_table[name].tsearch(term, config[:tsearch][:dictionary]).to_sql }
          Array(config[:dmetaphone][:columns]).each {|name| conditions << klass.arel_table[name].dmetaphone(term, config[:dmetaphone][:dictionary]).to_sql }
          conditions
        end

        where("#{conditions.join(' OR ')}")
      end

      def close_to(longitude, latitude, distance_in_miles = 5)
        distance_in_meters = (distance_in_miles.to_f * 1609.34).ceil
        where("ST_DWithin(
            ST_GeographyFromText('SRID=4326;POINT(' || licensees.longitude || ' ' || licensees.latitude || ')'),
            ST_GeographyFromText('SRID=4326;POINT(%f %f)'), %d
          )", longitude, latitude, distance_in_meters)
      end

      def rank_by(rank)
        # TODO: add ranks to projections
        puts "ranking by #{rank}"
        self
      end
    end
  end
end

ActiveRecord::Relation.send(:include, PgSearchable::ActiveRecord::Relation)
