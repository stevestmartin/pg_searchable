require 'active_record/relation'

module PgSearchable
  module ActiveRecord
    module Relation
      def search_for(term, options = {})
        puts "searching for #{term}"
      end

      def order_by_rank(rank)
        # TODO: add ranks to projections
        puts "ranking by #{rank}"
      end
    end
  end
end

ActiveRecord::Relation.send(:include, PgSearchable::ActiveRecord::Relation)
