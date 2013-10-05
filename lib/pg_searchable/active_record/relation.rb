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



      def rank_by(rank)
        # TODO: add ranks to projections
        puts "ranking by #{rank}"
        self
      end
    end
  end
end

ActiveRecord::Relation.send(:include, PgSearchable::ActiveRecord::Relation)
