--https://www.cybertec-postgresql.com/en/partition-management-do-you-really-need-a-tool-for-that/
SELECT
format('DROP TABLE IF EXISTS %s', subpartition_name) as sql_to_exec
FROM (
SELECT
format('%I.%I', n.nspname, c.relname) AS subpartition_name,
((regexp_match(pg_catalog.pg_get_expr(c.relpartbound, c.oid), $$ TO \('(.*)'\)$$))[1])::timestamptz AS part_end
FROM
pg_class p
JOIN pg_inherits i ON i.inhparent = p.oid
JOIN pg_class c ON c.oid = i.inhrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE
p.relname = 'event'
AND p.relkind = 'p'
AND n.nspname = 'subpartitions'
) x
WHERE
part_end < current_date - '6 months'::interval
ORDER BY
part_end;