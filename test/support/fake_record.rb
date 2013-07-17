module FakeRecord
  class Column < Struct.new(:name, :type)
  end

  class Connection
    attr_reader :tables
    attr_accessor :visitor

    def initialize(visitor = nil)
      @tables = %w{ articles categories comments users}
      @columns = {
        'articles' => [
          Column.new('id', :integer),
          Column.new('title', :string),
          Column.new('body', :text),
          Column.new('created_at', :date)
        ],
        'categories' => [
          Column.new('id', :integer),
          Column.new('name', :string)
        ]
      }
      @columns_hash = {
        'articles' => Hash[@columns['articles'].map { |x| [x.name, x] }],
        'categories' => Hash[@columns['categories'].map { |x| [x.name, x] }]
      }
      @primary_keys = {
        'articles' => 'id',
        'categories' => 'id'
      }
      @visitor = visitor
    end

    def columns_hash table_name
      @columns_hash[table_name]
    end

    def primary_key name
      @primary_keys[name.to_s]
    end

    def table_exists? name
      @tables.include? name.to_s
    end

    def columns name, message = nil
      @columns[name.to_s]
    end

    def quote_table_name name
      "\"#{name.to_s}\""
    end

    def quote_column_name name
      "\"#{name.to_s}\""
    end

    def schema_cache
      self
    end

    def quote thing, column = nil
      if column && column.type == :integer
        return 'NULL' if thing.nil?
        return thing.to_i
      end

      case thing
      when true
        "'t'"
      when false
        "'f'"
      when nil
        'NULL'
      when Numeric
        thing
      else
        "'#{thing}'"
      end
    end
  end

  class ConnectionPool
    class Spec < Struct.new(:config)
    end

    attr_reader :spec, :connection

    def initialize
      @spec = Spec.new(:adapter => 'america')
      @connection = Connection.new
      @connection.visitor = Arel::Visitors::ToSql.new(connection)
    end

    def with_connection
      yield connection
    end

    def table_exists? name
      connection.tables.include? name.to_s
    end

    def columns_hash
      connection.columns_hash
    end

    def schema_cache
      connection
    end
  end

  class Base
    attr_accessor :connection_pool

    def initialize
      @connection_pool = ConnectionPool.new
    end

    def connection
      connection_pool.connection
    end
  end
end
