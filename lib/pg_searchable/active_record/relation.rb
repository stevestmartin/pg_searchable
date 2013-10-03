require 'active_record/relation'

module PgSearchable
  module ActiveRecord
    module Relation
      def search_for(term, options = {})
        puts "searching for #{term}"
        self
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
