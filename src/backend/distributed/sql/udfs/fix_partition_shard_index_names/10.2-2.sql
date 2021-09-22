CREATE FUNCTION pg_catalog.fix_partition_shard_index_names(table_name regclass)
  RETURNS void
  LANGUAGE C STRICT
  AS 'MODULE_PATHNAME', $$fix_partition_shard_index_names$$;
COMMENT ON FUNCTION pg_catalog.fix_partition_shard_index_names(table_name regclass)
  IS 'fix index names on partition shards';

CREATE OR REPLACE FUNCTION pg_catalog.fix_partition_shard_index_names()
  RETURNS SETOF regclass
  LANGUAGE plpgsql
  AS $$
DECLARE
	oid regclass;
BEGIN
    FOR oid IN SELECT c.oid
            FROM pg_dist_partition p
            JOIN pg_class c ON p.logicalrelid = c.oid
        WHERE c.relkind = 'p'
		ORDER BY c.relname, c.oid
    LOOP
        EXECUTE 'SELECT fix_partition_shard_index_names( ' || quote_literal(oid) || ' )';
        RETURN NEXT oid;
    END LOOP;
    RETURN;
END;
$$;
COMMENT ON FUNCTION pg_catalog.fix_partition_shard_index_names()
  IS 'fix index names on all partition shards';
