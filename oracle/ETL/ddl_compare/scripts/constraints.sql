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
       || cstb
       || ' ADD CONSTRAINT '
       || constraint_name
       || ' PRIMARY KEY ('
       || column_names
       || ');'
  FROM ( (SELECT cs.constraint_name,
                 cs.table_name cstb,
                 cl.table_name cltb,
                 DBMS_LOB.SUBSTR (
                    (wm_concat (column_name)
                     OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                    4000,
                    1)
                    AS column_names,
                 COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                 position
            FROM dba_cons_columns@&2. cl, dba_constraints@&2. cs
           WHERE     cs.owner = '&1.'
                 AND cs.constraint_name = cl.constraint_name
                 AND cs.owner = cl.owner
                 AND cs.table_name NOT LIKE 'SYS_FBA%'
                 AND constraint_type IN ('P'))
        MINUS
        (SELECT cs.constraint_name,
                cs.table_name cstb,
                cl.table_name cltb,
                DBMS_LOB.SUBSTR (
                   (wm_concat (column_name)
                    OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                   4000,
                   1)
                   AS column_names,
                COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                position
           FROM dba_cons_columns@&4. cl, dba_constraints@&4. cs
          WHERE     cs.owner = '&3.'
                AND cs.constraint_name = cl.constraint_name
                AND cs.owner = cl.owner
                AND cs.table_name NOT LIKE 'SYS_FBA%'
                AND constraint_type IN ('P')))
 WHERE position = cnt;

PROMPT ---- FOREIGN KEYS
SELECT    'ALTER TABLE &3..'
       || tbl
       || ' ADD CONSTRAINT '
       || nmfk
       || ' FOREIGN KEY ('
       || column_names
       || ') REFERENCES &3..'
       || ref_tbl
       || '('
       || column_names
       || ') ENABLE VALIDATE;'
  FROM ( (SELECT nmfk,
                 tbl,
                 column_names,
                 ref_tbl
            FROM (SELECT fk.constraint_name nmfk,
                         fk.table_name tbl,
                         pk.table_name ref_tbl,
                         DBMS_LOB.SUBSTR (
                            (wm_concat (
                                column_name)
                             OVER (PARTITION BY cl.constraint_name
                                   ORDER BY position)),
                            4000,
                            1)
                            AS column_names,
                         COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                         position
                    FROM dba_cons_columns@&2. cl,
                         dba_constraints@&2. fk,
                         dba_constraints@&2. pk
                   WHERE     cl.owner = '&1.'
                         AND fk.constraint_type = 'R'
                         AND fk.r_constraint_name = pk.constraint_name
                         AND fk.constraint_name = cl.constraint_name
                         AND fk.owner = cl.owner
                         AND cl.owner = pk.owner)
           WHERE position = cnt)
        MINUS
        (SELECT nmfk,
                tbl,
                column_names,
                ref_tbl
           FROM (SELECT fk.constraint_name nmfk,
                        fk.table_name tbl,
                        pk.table_name ref_tbl,
                        DBMS_LOB.SUBSTR (
                           (wm_concat (
                               column_name)
                            OVER (PARTITION BY cl.constraint_name
                                  ORDER BY position)),
                           4000,
                           1)
                           AS column_names,
                        COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                        position
                   FROM dba_cons_columns@&4. cl,
                        dba_constraints@&4. fk,
                        dba_constraints@&4. pk
                  WHERE     cl.owner = '&3.'
                        AND fk.constraint_type = 'R'
                        AND fk.r_constraint_name = pk.constraint_name
                        AND fk.constraint_name = cl.constraint_name
                        AND fk.owner = cl.owner
                        AND cl.owner = pk.owner)
          WHERE position = cnt));

PROMPT ---- UNIQUE

SELECT    'ALTER TABLE &3..'
       || cstb
       || ' ADD CONSTRAINT '
       || constraint_name
       || ' PRIMARY KEY ('
       || column_names
       || ');'
  FROM ( (SELECT cs.constraint_name,
                 cs.table_name cstb,
                 cl.table_name cltb,
                 DBMS_LOB.SUBSTR (
                    (wm_concat (column_name)
                     OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                    4000,
                    1)
                    AS column_names,
                 COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                 position
            FROM dba_cons_columns@&2. cl, dba_constraints@&2. cs
           WHERE     cs.owner = '&1.'
                 AND cs.constraint_name = cl.constraint_name
                 AND cs.owner = cl.owner
                 AND cs.table_name NOT LIKE 'SYS_FBA%'
                 AND constraint_type IN ('U'))
        MINUS
        (SELECT cs.constraint_name,
                cs.table_name cstb,
                cl.table_name cltb,
                DBMS_LOB.SUBSTR (
                   (wm_concat (column_name)
                    OVER (PARTITION BY cl.constraint_name ORDER BY position)),
                   4000,
                   1)
                   AS column_names,
                COUNT (*) OVER (PARTITION BY cl.constraint_name) cnt,
                position
           FROM dba_cons_columns@&4. cl, dba_constraints@&4. cs
          WHERE     cs.owner = '&3.'
                AND cs.constraint_name = cl.constraint_name
                AND cs.owner = cl.owner
                AND cs.table_name NOT LIKE 'SYS_FBA%'
                AND constraint_type IN ('U')))
 WHERE position = cnt;