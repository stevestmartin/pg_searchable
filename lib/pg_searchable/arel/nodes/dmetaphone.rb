require 'arel/nodes/infix_operation'

module Arel
  module Nodes
    class Dmetaphone < Arel::Nodes::InfixOperation
      # TODO: create database function
      # CREATE OR REPLACE FUNCTION search_dmetaphone(text) RETURNS text LANGUAGE SQL IMMUTABLE STRICT AS $function$
      #   SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ')
      # $function$;

      def initialize(attribute, query, dictionary)
        relation  = attribute.relation
        columns   = relation.engine.connection.columns_hash(relation.name)
        left      = case columns[attribute.name.to_s].type
        when :tsvector
          attribute
        else
          Arel::Nodes::ToTsvector.new(attribute, dictionary)
        end

        super(:'@@', left, Arel::Nodes::ToTsquery.new(query, dictionary))
      end
    end
  end
end
