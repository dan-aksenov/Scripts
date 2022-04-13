--https://www.cybertec-postgresql.com/en/partition-management-do-you-really-need-a-tool-for-that/
WITH q_last_part AS (
select /* extract partition boundaries and take the last one */
*,
((regexp_match(part_expr, $$ TO \('(.*)'\)$$))[1])::timestamptz as last_part_end
from (
select /* get all current subpartitions of the 'event' table */
format('%I.%I', n.nspname, c.relname) as part_name,
pg_catalog.pg_get_expr(c.relpartbound, c.oid) as part_expr
from pg_class p
join pg_inherits i ON i.inhparent = p.oid
join pg_class c on c.oid = i.inhrelid
join pg_namespace n on n.oid = c.relnamespace
where p.relname = 'event' and p.relkind = 'p'
) x
order by last_part_end desc limit 1
)
SELECT
format($$CREATE TABLE IF NOT EXISTS subpartitions.event_y%sm%s PARTITION OF event FOR VALUES FROM ('%s') TO ('%s')$$,
extract(year from last_part_end),
lpad((extract(month from last_part_end))::text, 2, '0'),
last_part_end,
last_part_end + '1month'::interval)
AS sql_to_exec
FROM
q_last_part; -- \gexec