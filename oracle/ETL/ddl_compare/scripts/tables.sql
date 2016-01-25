--TABLES SCRIPT

PROMPT -- SURPLUS TABLES

  SELECT 'DROP TABLE &3..' || table_name || ' purge;'
    FROM (SELECT table_name
            FROM dba_tables@&4
           WHERE     owner = '&3'
                 AND table_name NOT LIKE '%$%'
                 AND table_name <> 'HEARTBEAT'
          MINUS
          SELECT table_name
            FROM dba_tables@&2
           WHERE owner = '&1')
   WHERE TABLE_NAME NOT LIKE 'SYS_FBA%'
ORDER BY table_name;

PROMPT -- MISSING TABLES

/*27.03.2014 добавлено: создание структуры таблицы*/
/*21.04.2015 добавлено: условие на созданине временных таблиц*/

  SELECT    'CREATE '||(case when temporary ='Y' then 'GLOBAL TEMPORARY' END)||' TABLE &3..'
         || table_name
         || ' AS SELECT * FROM &1..'
         || table_name
         || '@&2 where 1=0;'
    FROM (SELECT table_name,temporary
            FROM dba_tables@&2
           WHERE     owner = '&1'
                 AND table_name NOT LIKE '%$%'
                 AND table_name <> 'HEARTBEAT'
          MINUS
          SELECT table_name,temporary
            FROM dba_tables@&4
           WHERE owner = '&3')
   WHERE TABLE_NAME NOT LIKE 'SYS_FBA%'
ORDER BY table_name;