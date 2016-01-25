PROMPT -- SURPLUS PARTITIONS

SELECT    'ALTER TABLE &3..'
       || table_name
       || ' DROP PARTITION ('
       || partition_name
       || ')'
  FROM (SELECT table_name, partition_name
          FROM dba_tab_partitions@&4
         WHERE     table_owner = '&3'
               AND table_name NOT LIKE '%$%'
               AND table_name NOT IN (SELECT table_name
                                        FROM dba_tables@&4
                                       WHERE     owner = '&3'
                                             AND table_name NOT LIKE '%$%'
                                      MINUS
                                      SELECT table_name
                                        FROM dba_tables@&2
                                       WHERE owner = '&1')
        MINUS
        SELECT table_name, partition_name
          FROM dba_tab_partitions@&2
         WHERE table_owner = '&1')
 WHERE TABLE_NAME NOT LIKE 'SYS_FBA%';


PROMPT -- MISSING PARTITIONS

SELECT    '-- ALTER TABLE &3..'
       || table_name
       || ' ADD PARTITION ('
       || partition_name
       || ')'
  FROM (SELECT table_name, partition_name
          FROM dba_tab_partitions@&2
         WHERE     table_owner = '&1'
               AND table_name NOT LIKE '%$%'
               AND table_name NOT IN (SELECT table_name
                                        FROM dba_tables@&2
                                       WHERE     owner = '&1'
                                             AND table_name NOT LIKE '%$%'
                                      MINUS
                                      SELECT table_name
                                        FROM dba_tables@&4
                                       WHERE owner = '&3')
        MINUS
        SELECT table_name, partition_name
          FROM dba_tab_partitions@&4
         WHERE table_owner = '&3')
 WHERE TABLE_NAME NOT LIKE 'SYS_FBA%';
