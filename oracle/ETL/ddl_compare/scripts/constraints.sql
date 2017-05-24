PROMPT -- SURPLUS CONSTRAINTS

SELECT    'ALTER TABLE &3..'
       || table_name
       || ' DROP CONSTRAINT '
       || constraint_name
       || ';'
  FROM (SELECT table_name,
               constraint_name,
               constraint_type,
               r_constraint_name
          FROM dba_constraints@&4
         WHERE     constraint_type IN ('P', 'R')
               AND owner = '&3'
               AND table_name NOT LIKE '%$%'
               AND table_name <> 'HEARTBEAT'
        MINUS
        SELECT table_name,
               constraint_name,
               constraint_type,
               r_constraint_name
          FROM dba_constraints@&2
         WHERE constraint_type IN ('P', 'R') AND owner = '&1')
 WHERE TABLE_NAME NOT LIKE 'SYS_FBA%';

PROMPT -- MISSING CONSTRAINTS

PROMPT ---- PRIMARY KEYS

SELECT    'ALTER TABLE &3..'
       || cl.cltb
       || ' ADD CONSTRAINT '
       || cl.constraint_name
       || ' PRIMARY KEY ('
       || cl.column_names
       || ');'
       from ((select * from (SELECT cl.constraint_name,
                 cl.table_name cltb,
                 DBMS_LOB.SUBSTR (
                    (wm_concat (column_name)
                     OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                    4000,
                    1)
                    AS column_names,
                 COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                 position
            FROM dba_cons_columns@&2. cl
           WHERE     cl.owner = '&1.'
                 ) where position=cnt
                 )
        MINUS
        (select * from (SELECT cl.constraint_name,
                cl.table_name cltb,
                DBMS_LOB.SUBSTR (
                   (wm_concat (column_name)
                    OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                   4000,
                   1)
                   AS column_names,
                COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                position
           FROM dba_cons_columns@&4. cl
          WHERE     cl.owner = '&3.'
                    )
                WHERE position = cnt
                )) cl,dba_constraints cn where owner = '&1.' and 
                cn.constraint_name=cl.constraint_name
                and cltb=table_name and constraint_type='P';

PROMPT ---- FOREIGN KEYS

SELECT    'ALTER TABLE &3..'
       || cl.cltb
       || ' ADD CONSTRAINT '
       || cl.constraint_name
       || ' FOREIGN KEY ('
       || cl.column_names
       || ') REFERENCES &3..'
       || cl.cltb
       || '('
       || cl.column_names
       || ') ENABLE VALIDATE;'
  FROM ((select * from (SELECT cl.constraint_name,
                 cl.table_name cltb,
                 DBMS_LOB.SUBSTR (
                    (wm_concat (column_name)
                     OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                    4000,
                    1)
                    AS column_names,
                 COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                 position
            FROM dba_cons_columns@&2. cl
           WHERE     cl.owner = '&1.'
                 ) where position=cnt
                 )
        MINUS
        (select * from (SELECT cl.constraint_name,
                cl.table_name cltb,
                DBMS_LOB.SUBSTR (
                   (wm_concat (column_name)
                    OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                   4000,
                   1)
                   AS column_names,
                COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                position
           FROM dba_cons_columns@&4. cl
          WHERE     cl.owner = '&3.'
                    )
                WHERE position = cnt
                )) cl,dba_constraints cn where owner = '&1.' and 
                cn.constraint_name=cl.constraint_name
                and cltb=table_name and constraint_type='R';

PROMPT ---- UNIQUE

SELECT    'ALTER TABLE &3..'
       || cl.cltb
       || ' ADD CONSTRAINT '
       || cl.constraint_name
       || ' as UNIQUE ('
       || cl.column_names
       || ') ENABLE VALIDATE;'
       from ((select * from (SELECT cl.constraint_name,
                 cl.table_name cltb,
                 DBMS_LOB.SUBSTR (
                    (wm_concat (column_name)
                     OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                    4000,
                    1)
                    AS column_names,
                 COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                 position
            FROM dba_cons_columns@&2. cl
           WHERE     cl.owner = '&1.'
                 ) where position=cnt
                 )
        MINUS
        (select * from (SELECT cl.constraint_name,
                cl.table_name cltb,
                DBMS_LOB.SUBSTR (
                   (wm_concat (column_name)
                    OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                   4000,
                   1)
                   AS column_names,
                COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                position
           FROM dba_cons_columns@&4. cl
          WHERE     cl.owner = '&3.'
                    )
                WHERE position = cnt
                )) cl,dba_constraints cn where owner = '&1.' and 
                cn.constraint_name=cl.constraint_name
                and cltb=table_name and constraint_type='U';