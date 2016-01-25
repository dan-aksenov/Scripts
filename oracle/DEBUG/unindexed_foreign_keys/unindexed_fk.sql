conn dbax/dbax@&2.
set term off
set ver off
spoo log\check_fk_&2..log
-- from MOS
drop table foreign_key_exceptions purge;

CREATE TABLE foreign_key_exceptions
(owner VARCHAR2(30),
constraint_name VARCHAR2(30),
status VARCHAR2(8),
table_name VARCHAR2(30),
foreign_key VARCHAR2(2000));

set heading off

set echo off
SET SERVEROUTPUT ON FORMAT WRAPPED

declare
  WRITE_TO_TABLE_Y_N VARCHAR2(1) DEFAULT 'Y';
  from_schema    VARCHAR2(30);
  to_schema      VARCHAR2(30);
  pl_cons_column VARCHAR2(30);
  pl_foreign_key VARCHAR2(2000);
  pl_ind_column  VARCHAR2(30);
  pl_ind_name    VARCHAR2(30);
  pl_ind_owner   VARCHAR2(30);
  pl_index       VARCHAR2(2000);
  f_owner        VARCHAR2(30);
  f_table_name   VARCHAR2(30);
/*
   Cursor c1 simply selects each Foreign Key constraint from the 
   DBA View DBA_CONSTRAINTS. No need at this stage to limit the 
   query to 'ENABLED' constraints, we'll simply report the status 
   in the log file. For each constraint, we'll construct the column list, 
   using cursor c2, which combine to form the foreign key constraint
   returned in cursor c1 
*/
  CURSOR c1 IS SELECT constraint_name,owner,table_name,status,r_owner,r_constraint_name
                 FROM dba_constraints
                WHERE constraint_type='R'
                 AND   owner between upper(from_schema) and upper(to_schema)
                ORDER BY owner;
  CURSOR c2(cons_name VARCHAR2,cons_owner VARCHAR2) IS SELECT column_name
                 FROM dba_cons_columns
                WHERE constraint_name=cons_name
                  AND owner=cons_owner
                ORDER BY dba_cons_columns.position;
/*
   For each returned constraint, we need to fins a matching index, firstly
   we fetch each index name with c3, and then construct the index columns
   with cursor c4 in their correct order until we find a match with the 
   foreign key constraint
*/
  CURSOR c3(ind_table varchar2,tab_owner varchar2) IS
                 SELECT index_name, owner
                 FROM dba_indexes
                WHERE table_name=ind_table
                  AND table_owner=tab_owner;
  CURSOR c4(ind_name varchar2,ind_owner varchar2) IS
                 SELECT column_name
                 FROM dba_ind_columns
                WHERE INDEX_NAME=ind_name
                  AND INDEX_OWNER=ind_owner
                 ORDER BY dba_ind_columns.column_position;
CURSOR c5(for_owner varchar2,for_constraint varchar2) IS
                 SELECT owner,table_name
                 FROM dba_constraints
                WHERE OWNER=for_owner
                  AND CONSTRAINT_NAME=for_constraint;

BEGIN
--WRITE_TO_TABLE_Y_N:='WRITE_TO_TABLE_Y_N';
from_schema:= '&1.';
IF from_schema = 'ALL' THEN
  begin
    from_schema := 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    to_schema := 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ';
  end;
ELSE
  to_schema := from_schema;
END IF;
DBMS_OUTPUT.PUT_LINE('                         Missing Indexes for Foreign Keys');
DBMS_OUTPUT.PUT_LINE('                         --------------------------------');

  FOR c1_rec in c1 LOOP
/* looping for each foreign key constraint */
    pl_cons_column := NULL;
    pl_foreign_key := NULL;
    pl_ind_column := NULL;
    pl_ind_name := NULL;
    pl_ind_owner := NULL;
    pl_index := NULL;
    f_owner:=NULL;
    F_table_name:=NULL;
OPEN c5(c1_rec.r_owner,c1_rec.r_constraint_name);
FETCH c5 INTO f_owner,f_table_name;
CLOSE c5;
    OPEN c2(c1_rec.constraint_name,c1_rec.owner);
    FETCH c2 INTO pl_cons_column;
    pl_foreign_key := pl_cons_column; -- the first col in the foreign key
<<constraint_names>>
    LOOP
/*
constructing the foreign key columns, delimiting each column with a ',' 
*/
      FETCH c2 into pl_cons_column;
      EXIT WHEN c2%NOTFOUND;
      pl_foreign_key := pl_foreign_key||','||pl_cons_column;
    END LOOP constraint_names;
/* 
we now have a table and foreign key definition for which we need an index */
    CLOSE c2;
    OPEN c3(c1_rec.table_name,c1_rec.owner);
<<index_name>>
    LOOP
/* for each index found for this table */
      FETCH c3 INTO pl_ind_name,pl_ind_owner;
      EXIT WHEN c3%NOTFOUND;
      OPEN c4(pl_ind_name,pl_ind_owner);
      FETCH c4 INTO pl_ind_column;
      pl_index := pl_ind_column;        -- the first column in the index
      IF pl_index=pl_foreign_key THEN   -- check this doesn't already match 
        CLOSE c4;                       -- the foreign key
        EXIT index_name;
      END IF;
      IF pl_index = SUBSTR(pl_foreign_key,1,LENGTH(pl_index)) THEN
/* 
   we only need construct the whole index while it's leading edge still 
   matches the constrained foreign key columns
*/
<<index_columns>>
        LOOP
/*  construct the whole index in the same way as the foreign key */
          FETCH c4 INTO pl_ind_column;
          EXIT WHEN c4%NOTFOUND;
          pl_index:= pl_index||','||pl_ind_column;
/*
    we do not need to continue with the index name loop if we already have a
    match on the foreign key 
*/
          IF pl_index=pl_foreign_key
          THEN
            CLOSE c4;
            EXIT index_name;
          END IF;
/*
   if the leading edge differs - go back around the loop to see if there is a 
   subsequent index that matches
*/
          IF pl_index != SUBSTR(pl_foreign_key,1,LENGTH(pl_index))
          THEN
             EXIT index_columns;
          END IF;
        END LOOP index_columns;
      END IF;
      CLOSE c4;
    END LOOP index_name;
    CLOSE c3;
    IF pl_index != pl_foreign_key OR pl_index IS NULL THEN
/*
      Alternative means of output having first set serveroutput using: 
            SET SERVEROUTPUT ON SIZE n
      where n is between 2000 and 1000000 to set the output limit.
      DBMS_OUTPUT.PUT_LINE(c1_rec.owner||'.'||c1_rec.constraint_name);
*/
IF WRITE_TO_TABLE_Y_N ='Y' or   WRITE_TO_TABLE_Y_N ='y' THEN
     INSERT INTO foreign_key_exceptions VALUES (c1_rec.owner,c1_rec.constraint_name,c1_rec.status, c1_rec.table_name,pl_foreign_key);
END IF;
/* sdixon: Changed from EXECute immedaite which generated ORA-984 - from comment HP ID 2327281
      EXECUTE IMMEDIATE 'INSERT INTO foreign_key_exceptions VALUES (c1_rec.owner,c1_rec.constraint_name,c1_rec.status, c1_rec.table_name,pl_foreign_key)';
*/
--dbms_output.put_line('Constraint  '||c1_rec.constraint_name||'('||c1_rec.status||') : Changing data in table '||f_owner||'.'||f_table_name||' will lock table '||c1_rec.owner||'.'||c1_rec.table_name);
--dbms_output.put_line('Create index for table '||c1_rec.owner||'.'||c1_rec.table_name||' on columns '||pl_foreign_key);
--dbms_output.put_line('************************');

      COMMIT;
    END IF;
  END LOOP;
END;
/
--undefine WRITE_TO_TABLE_Y_N
--undefine SCHEMA

-- DBAX create indexes based on MOS script

CREATE TABLE foreign_key_cre_idx
   (
      sch   VARCHAR2 (200),
      tbl   VARCHAR2 (200),
      idx   VARCHAR2 (200),
      num   NUMBER,
      cmd   VARCHAR2 (2000)
   );

DECLARE
   l_num       NUMBER;                            -- index suffix for NAME_I00
   l_idx       VARCHAR2 (100);     -- index name made from table_name + suffix
   l_cmd       VARCHAR2 (2000);                        -- create index command

   l_tbl       VARCHAR2 (100);                                -- indexed table

   --array to hold existing indexes of tables
   TYPE v_array IS TABLE OF VARCHAR2 (200);

   idx_array   v_array;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE foreign_key_cre_idx'; -- table must exist.

   -- table's  definition
   /*   CREATE TABLE foreign_key_cre_idx
   (
      sch   VARCHAR2 (200),
      tbl   VARCHAR2 (200),
      idx   VARCHAR2 (200),
      num   NUMBER,
      cmd   VARCHAR2 (2000)
   );*/

   -- select from table created by ORACLE's script.
   FOR i IN (SELECT *
               FROM foreign_key_exceptions)
   LOOP
      BEGIN
         --default indexname and number suffix
         l_num := 1;

         l_tbl := SUBSTR (i.table_name, 0, 26); -- substr 26, so index_name_i00 can be =<30. (TODO: add workaround for names like I000 and more.)

         l_idx := l_tbl || '_I' || l_num;

         -- init array on dba_indexes and check if name already exists.
         SELECT index_name
           BULK COLLECT INTO idx_array
           FROM dba_indexes
          WHERE owner = i.owner;

         IF l_idx MEMBER OF idx_array
         THEN
            SELECT MAX (
                      TO_NUMBER (
                         SUBSTR (REGEXP_SUBSTR (index_name, '_I\d{1,}$'), 3))) --if there are already indexes whith name like NAME_I00, select max N and add 1
              INTO l_num
              FROM dba_indexes
             WHERE     owner = i.owner
                   AND table_name = i.table_name
                   AND REGEXP_LIKE (index_name, '_I\d{1,}$');

            --dbms_output.put_line(l_num);
            l_num := l_num + 1;
         END IF;

         --init array for names alreay used in THIS script
         SELECT tbl
           BULK COLLECT INTO idx_array
           FROM foreign_key_cre_idx where sch=i.owner and tbl=i.table_name;

         IF i.table_name MEMBER OF idx_array
         THEN
            SELECT MAX (num)
              INTO l_num
              FROM foreign_key_cre_idx
             WHERE tbl = i.table_name
		and sch = i.owner;

            l_num := l_num + 1;
         END IF;

         --final index_name
         l_idx := l_tbl || '_I' || l_num;

         --dbms_output.put_line(l_idx);
         l_cmd :=
               'create index '
            || i.owner
            || '.'
            || l_idx
            || ' on '
            || i.owner
            || '.'
            || i.table_name
            || '('
            || i.foreign_key
            || ') ONLINE;';

         INSERT INTO foreign_key_cre_idx
              VALUES (i.owner,
                      i.table_name,
                      l_idx,
                      l_num,
                      l_cmd);

         --delete from unindexed_foreign_key where sch=i.owner and tbl=i.table_name;
         insert into unindexed_foreign_key values ('&2.',sysdate,i.owner,
                      i.table_name,
                      l_idx,
                      l_num,
                      l_cmd );
         COMMIT;
      --DBMS_OUTPUT.put_line (l_cmd);
      --execute immediate l_cmd;



      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (SQLERRM);
      END;
   END LOOP;
END;
/
spoo off
exit