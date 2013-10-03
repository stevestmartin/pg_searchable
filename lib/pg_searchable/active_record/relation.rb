require 'active_record/relation'

module PgSearchable
  module ActiveRecord
    module Relation
      def search_for(term, options = {})
        using       = Array(options.delete(:using) || :default)
        config_name = using.find {|name| pg_searchable_configs.key?(name.to_sym) }
        config      = pg_searchable_configs[config_name]

        tgrm        = Array(config[:tgrm][:columns]).map        {|name| arel_table[name].tgrm(term).to_sql }
        tsearch     = Array(config[:tsearch][:columns]).map     {|name| arel_table[name].tsearch(term, config[:tsearch][:dictionary]).to_sql }
        dmetaphone  = Array(config[:dmetaphone][:columns]).map  {|name| arel_table[name].dmetaphone(term, config[:dmetaphone][:dictionary]).to_sql }

        where("#{[tsearch, dmetaphone, tgrm].flatten.join(' OR ')}")
      end

      def near(latitude, longitude)
        puts "searching near #{latitude},#{longitude}"
        self
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
