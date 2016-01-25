--COLUMNS SCRIPT

PROMPT -- SURPLUS COLUMNS -- todo: add cascade constraints

SELECT 'ALTER TABLE &3..' || table_name || ' DROP ("' || column_name || '");'
  FROM (SELECT table_name, column_name
          FROM dba_tab_columns@&4 a
         WHERE     owner = '&3'
               AND table_name NOT LIKE '%$%'
               AND NOT EXISTS
                      (SELECT 1
                         FROM dba_views@&4
                        WHERE owner = '&3' AND a.table_name = view_name)
               AND table_name NOT IN (SELECT table_name
                                        FROM dba_tables@&4
                                       WHERE     owner = '&3'
                                             AND table_name NOT LIKE '%$%'
                                      MINUS
                                      SELECT table_name
                                        FROM dba_tables@&2
                                       WHERE owner = '&1')
               AND table_name IN (SELECT table_name
                                    FROM dba_tables@&4
                                   WHERE owner = '&3'
                                  INTERSECT
                                  SELECT table_name
                                    FROM dba_tables@&2
                                   WHERE owner = '&1')
        MINUS
        SELECT table_name, column_name
          FROM dba_tab_columns@&2
         WHERE owner = '&1')
 WHERE TABLE_NAME NOT LIKE 'SYS_FBA%';


PROMPT -- MISSING COLUMNS

SELECT    'ALTER TABLE &3..'
       || table_name
       || ' ADD ("'
       || column_name
       || '" '
       || data_type
       || CASE
             WHEN data_type = 'VARCHAR2' THEN '(' || data_length || ')'
             ELSE ' '
          END
       || ');'
  FROM dba_tab_columns@&2 a
 WHERE     owner = '&1'
       AND table_name NOT LIKE '%$%'
       AND table_name <> 'HEARTBEAT'
       AND TABLE_NAME NOT LIKE 'SYS_FBA%'
       AND NOT EXISTS
              (SELECT 1
                 FROM dba_views@&2
                WHERE owner = '&1' AND a.table_name = view_name)
       AND table_name IN (SELECT table_name
                            FROM dba_tables@&4
                           WHERE owner = '&3'
                          INTERSECT
                          SELECT table_name
                            FROM dba_tables@&2
                           WHERE owner = '&1')
       AND table_name NOT IN (SELECT table_name
                                FROM dba_tables@&2
                               WHERE     owner = '&1'
                                     AND table_name NOT LIKE '%$%'
                              MINUS
                              SELECT table_name
                                FROM dba_tables@&4
                               WHERE owner = '&3')
       AND (table_name, column_name) IN (SELECT table_name, column_name
                                           FROM dba_tab_columns@&2
                                          WHERE owner = '&1'
                                         MINUS
                                         SELECT table_name, column_name
                                           FROM dba_tab_columns@&4
                                          WHERE owner = '&3');


PROMPT -- COLUMNS DEFFERS BY TYPE, SIZE

SELECT    'ALTER TABLE &3..'
       || table_name
       || ' MODIFY ("'
       || column_name
       || '" '
       || data_type
       || ''
       || CASE
             WHEN data_type IN ('VARCHAR2', 'CHAR')
             THEN
                '(' || data_length || ')'
             ELSE
                ' '
          END
       || ');'
  FROM (SELECT table_name,
               column_name,
               data_type,
               data_length
          FROM dba_tab_columns@&2
         WHERE     owner = '&1'
               AND NOT EXISTS
                      (SELECT 1
                         FROM dba_views@&2
                        WHERE owner = '&1' AND table_name = view_name)
        MINUS
        SELECT table_name,
               column_name,
               data_type,
               data_length
          FROM dba_tab_columns@&4
         WHERE     owner = '&3'
               AND NOT EXISTS
                      (SELECT 1
                         FROM dba_views@&4
                        WHERE owner = '&3' AND table_name = view_name))
 WHERE     table_name <> 'HEARTBEAT'
       AND TABLE_NAME NOT LIKE 'SYS_FBA%'
       AND (table_name, column_name) IN (SELECT table_name, column_name
                                           FROM dba_tab_columns@&2
                                          WHERE owner = '&1'
                                         INTERSECT
                                         SELECT table_name, column_name
                                           FROM dba_tab_columns@&4
                                          WHERE owner = '&3');


PROMPT -- COLUMNS DIFFERS BY null

SELECT    'ALTER TABLE &3..'
       || table_name
       || ' MODIFY ("'
       || column_name
       || '" '
       || CASE WHEN nullable = 'Y' THEN ' NULL' ELSE ' NOT NULL' END
       || ');'
  FROM (SELECT table_name, column_name, nullable
          FROM dba_tab_columns@&2
         WHERE     owner = '&1'
               AND NOT EXISTS
                      (SELECT 1
                         FROM dba_views@&2
                        WHERE owner = '&1' AND table_name = view_name)
        MINUS
        SELECT table_name, column_name, nullable
          FROM dba_tab_columns@&4
         WHERE     owner = '&3'
               AND NOT EXISTS
                      (SELECT 1
                         FROM dba_views@&4
                        WHERE owner = '&3' AND table_name = view_name))
 WHERE     table_name <> 'HEARTBEAT'
       AND (table_name, column_name) IN (SELECT table_name, column_name
                                           FROM dba_tab_columns@&2
                                          WHERE owner = '&1'
                                         INTERSECT
                                         SELECT table_name, column_name
                                           FROM dba_tab_columns@&4
                                          WHERE owner = '&3')
       AND TABLE_NAME NOT LIKE 'SYS_FBA%';

PROMPT -- COLUMNS DIFFERS BY ORDER

  SELECT *
    FROM (SELECT '-- &2',
                 table_name,
                 column_name,
                 column_id
            FROM dba_tab_columns@&2
           WHERE     owner = '&1'
                 AND table_name NOT LIKE '%$%'
                 AND NOT EXISTS
                        (SELECT 1
                           FROM dba_views@&2
                          WHERE owner = '&1' AND table_name = view_name)
          UNION ALL
          SELECT '-- &4',
                 table_name,
                 column_name,
                 column_id
            FROM dba_tab_columns@&4
           WHERE     owner = '&3'
                 AND NOT EXISTS
                        (SELECT 1
                           FROM dba_views@&4
                          WHERE owner = '&3' AND table_name = view_name))
   WHERE     (table_name, column_name) IN (SELECT table_name, column_name
                                             FROM (SELECT table_name,
                                                          column_name,
                                                          column_id
                                                     FROM dba_tab_columns@&2
                                                    WHERE     owner = '&1'
                                                          AND table_name NOT LIKE
                                                                 '%$%'
                                                   MINUS
                                                   SELECT table_name,
                                                          column_name,
                                                          column_id
                                                     FROM dba_tab_columns@&4
                                                    WHERE owner = '&3')
                                            WHERE (table_name, column_name) IN (SELECT table_name,
                                                                                       column_name
                                                                                  FROM dba_tab_columns@&2
                                                                                 WHERE     owner =
                                                                                              '&1'
                                                                                       AND table_name NOT LIKE
                                                                                              '%$%'
                                                                                INTERSECT
                                                                                SELECT table_name,
                                                                                       column_name
                                                                                  FROM dba_tab_columns@&4
                                                                                 WHERE owner =
                                                                                          '&3'))
         AND TABLE_NAME NOT LIKE 'SYS_FBA%'
ORDER BY 2, 3, 4;