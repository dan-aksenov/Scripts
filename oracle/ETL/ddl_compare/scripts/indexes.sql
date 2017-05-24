--INDEXES SCRIPT

PROMPT -- SURPLUS INDEXES

SELECT 'DROP INDEX &3..' || index_name || ';'
  FROM (SELECT table_name, index_name
          FROM dba_indexes@&4
         WHERE     owner = '&3'
               AND table_name NOT LIKE '%$%'
               AND index_type <> 'LOB'
               AND table_name <> 'HEARTBEAT'
               AND TABLE_NAME NOT LIKE 'SYS_FBA%'
        MINUS
        SELECT table_name, index_name
          FROM dba_indexes@&2
         WHERE owner = '&1' AND TABLE_NAME NOT LIKE 'SYS_FBA%');

PROMPT -- MISSING UNIQUE INDEXES

--14.04.2014 изменен механизм сравнения индексов с учетом порядка колонок

SELECT    'CREATE UNIQUE INDEX &3..'
       || index_name
       || ' ON &3..'
       || table_name
       || '('
       || column_names
       || ');'
  FROM (SELECT i.table_name,
               i.index_name,
               i.index_type,
               DBMS_LOB.SUBSTR (
                  (wm_concat (
                      c.column_name)
                   OVER (PARTITION BY c.index_name
                         ORDER BY c.column_position)),
                  4000,
                  1)
                  AS column_names,
               COUNT (*) OVER (PARTITION BY i.index_name) cnt,
               c.column_position
          FROM dba_indexes@&2. i, dba_ind_columns@&2. c
         WHERE     c.index_name = i.index_name
               AND i.owner = '&1.'
               AND i.table_name NOT LIKE '%$%'
               AND i.index_type <> 'LOB'
               AND i.index_type NOT LIKE 'FUNC%'
               AND i.uniqueness = 'UNIQUE'
               AND i.table_name <> 'HEARTBEAT'
               AND i.owner = c.index_owner
        MINUS
        SELECT i.table_name,
               i.index_name,
               i.index_type,
               DBMS_LOB.SUBSTR (
                  (wm_concat (
                      c.column_name)
                   OVER (PARTITION BY c.index_name
                         ORDER BY c.column_position)),
                  4000,
                  1)
                  AS column_names,
               COUNT (*) OVER (PARTITION BY i.index_name) cnt,
               c.column_position
          FROM dba_indexes@&4. i, dba_ind_columns@&4. c
         WHERE     c.index_name = i.index_name
               AND i.owner = '&3.'
               AND i.table_name NOT LIKE '%$%'
               AND i.index_type <> 'LOB'
               AND i.uniqueness = 'UNIQUE'
               AND i.table_name <> 'HEARTBEAT'
               AND i.owner = c.index_owner)
 WHERE cnt = column_position AND TABLE_NAME NOT LIKE 'SYS_FBA%';

PROMPT -- MISSING INDEXES

/*14.04.2014 изменен механизм сравнения индексов с учетом порядка колонок*/

SELECT    'CREATE INDEX &3..'
       || index_name
       || ' ON &3..'
       || table_name
       || '('
       || column_names
       || ');'
  FROM (SELECT i.table_name,
               i.index_name,
               i.index_type,
               DBMS_LOB.SUBSTR (
                  (wm_concat (
                      c.column_name)
                   OVER (PARTITION BY c.index_name
                         ORDER BY c.column_position)),
                  4000,
                  1)
                  AS column_names,
               COUNT (*) OVER (PARTITION BY i.index_name) cnt,
               c.column_position
          FROM dba_indexes@&2. i, dba_ind_columns@&2. c
         WHERE     c.index_name = i.index_name
               AND i.owner = '&1.'
               AND i.table_name NOT LIKE '%$%'
               AND i.index_type <> 'LOB'
               AND i.index_type NOT LIKE 'FUNC%'
               AND i.uniqueness <> 'UNIQUE'
               AND i.table_name <> 'HEARTBEAT'
               AND i.owner = c.index_owner
        MINUS
        SELECT i.table_name,
               i.index_name,
               i.index_type,
               DBMS_LOB.SUBSTR (
                  (wm_concat (
                      c.column_name)
                   OVER (PARTITION BY c.index_name
                         ORDER BY c.column_position)),
                  4000,
                  1)
                  AS column_names,
               COUNT (*) OVER (PARTITION BY i.index_name) cnt,
               c.column_position
          FROM dba_indexes@&4. i, dba_ind_columns@&4. c
         WHERE     c.index_name = i.index_name
               AND i.owner = '&3.'
               AND i.table_name NOT LIKE '%$%'
               AND i.index_type <> 'LOB'
               AND i.uniqueness <> 'UNIQUE'
               AND i.table_name <> 'HEARTBEAT'
               AND i.owner = c.index_owner)
 WHERE cnt = column_position AND TABLE_NAME NOT LIKE 'SYS_FBA%';
 
-- added 21.12.2015 indexes by visibility
PROMPT --INDEXES BY VISIBILITY
 
select 'ALTER INDEX &3..'||index_name||' VISIBLE;' from (
SELECT table_name, index_name, status, visibility
          FROM dba_indexes@&4
         WHERE     owner = '&3'
               AND table_name NOT LIKE '%$%'
               AND index_type <> 'LOB'
               AND table_name <> 'HEARTBEAT'
               AND TABLE_NAME NOT LIKE 'SYS_FBA%'
        MINUS
        SELECT table_name, index_name, status, visibility
          FROM dba_indexes@&2
         WHERE owner = '&1' AND TABLE_NAME NOT LIKE 'SYS_FBA%'); 