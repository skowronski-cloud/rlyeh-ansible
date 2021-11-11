-- To use IF statements, hence to be able to check if the user exists before
-- attempting creation, we need to switch to procedural SQL (PL/pgSQL)
-- instead of standard SQL.
-- More: https://www.postgresql.org/docs/9.3/plpgsql-overview.html
-- To preserve compatibility with <9.0, DO blocks are not used; instead,
-- a function is created and dropped.
CREATE OR REPLACE FUNCTION __tmp_create_user() returns void as $$
BEGIN
  IF NOT EXISTS (
          SELECT                       -- SELECT list can stay empty for this
          FROM   pg_catalog.pg_user
          WHERE  usename = '{{ postgres_dbs.exporter.user }}') THEN
    CREATE USER {{ postgres_dbs.exporter.user }};
  END IF;
END;
$$ language plpgsql;

SELECT __tmp_create_user();
DROP FUNCTION __tmp_create_user();

ALTER USER {{ postgres_dbs.exporter.user}} SET SEARCH_PATH TO {{postgres_dbs.exporter.user }},pg_catalog;

-- If deploying as non-superuser (for example in AWS RDS), uncomment the GRANT
-- line below and replace <MASTER_USER> with your root user.
-- GRANT {{ postgres_dbs.exporter.user }} TO <MASTER_USER>;
CREATE SCHEMA IF NOT EXISTS {{ postgres_dbs.exporter.user }};
GRANT USAGE ON SCHEMA {{ postgres_dbs.exporter.user}} TO {{postgres_dbs.exporter.user }};
GRANT CONNECT ON DATABASE postgres TO {{ postgres_dbs.exporter.user }};

CREATE OR REPLACE FUNCTION get_pg_stat_activity() RETURNS SETOF pg_stat_activity AS
$$ SELECT * FROM pg_catalog.pg_stat_activity; $$
LANGUAGE sql
VOLATILE
SECURITY DEFINER;

CREATE OR REPLACE VIEW {{ postgres_dbs.exporter.user }}.pg_stat_activity
AS
  SELECT * from get_pg_stat_activity();

GRANT SELECT ON {{ postgres_dbs.exporter.user}}.pg_stat_activity TO {{postgres_dbs.exporter.user }};

CREATE OR REPLACE FUNCTION get_pg_stat_replication() RETURNS SETOF pg_stat_replication AS
$$ SELECT * FROM pg_catalog.pg_stat_replication; $$
LANGUAGE sql
VOLATILE
SECURITY DEFINER;

CREATE OR REPLACE VIEW {{ postgres_dbs.exporter.user }}.pg_stat_replication
AS
  SELECT * FROM get_pg_stat_replication();

GRANT SELECT ON {{ postgres_dbs.exporter.user}}.pg_stat_replication TO {{postgres_dbs.exporter.user }};
