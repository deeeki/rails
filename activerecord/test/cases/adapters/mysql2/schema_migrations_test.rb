require "cases/helper"

module ActiveRecord
  module ConnectionAdapters
    class Mysql2Adapter
      class SchemaMigrationsTest < ActiveRecord::TestCase
        def setup
          super
          @conn = ActiveRecord::Base.connection
          @smtn = ActiveRecord::Migrator.schema_migrations_table_name
          @config = @conn.instance_variable_get(:@config)
        end

        def test_initializes_schema_migrations_for_encoding_utf8mb4
          @conn.drop_table(@smtn) if @conn.table_exists?(@smtn)
          original_encoding = @config[:encoding]
          @config[:encoding] = 'utf8mb4'

          @conn.initialize_schema_migrations_table

          assert @conn.column_exists?(@smtn, :version, :string, limit: Mysql2Adapter::MAX_INDEX_LENGTH_FOR_UTF8MB4)
        ensure
          @config[:encoding] = original_encoding
        end

        def test_initializes_schema_migrations_through_migrator_for_encoding_utf8mb4
          @conn.drop_table(@smtn) if @conn.table_exists?(@smtn)
          original_encoding = @config[:encoding]
          @config[:encoding] = 'utf8mb4'

          ActiveRecord::Migrator.new(:up, [])

          assert @conn.column_exists?(@smtn, :version, :string, limit: Mysql2Adapter::MAX_INDEX_LENGTH_FOR_UTF8MB4)
        ensure
          @config[:encoding] = original_encoding
        end
      end
    end
  end
end
