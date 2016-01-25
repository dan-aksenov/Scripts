PROMPT -- MISSING GRANTS FOREIGN
SELECT 'grant '||privilege||' on '||grantor||'.'||table_name||' to '||grantee||';' FROM (
            SELECT privilege, grantor, table_name, grantee
			FROM dba_tab_privs@&2
           WHERE     GRANTOR = '&1'
          MINUS
          SELECT privilege, grantor, table_name, grantee
            FROM dba_tab_privs@&4
           WHERE GRANTOR = '&3');

PROMPT -- SURPLUS GRANTS FOREIGN

SELECT 'REVOKE '||privilege||' on '||grantor||'.'||table_name||' FROM '||grantee||';' FROM (
            SELECT privilege, grantor, table_name, grantee
			FROM dba_tab_privs@&4
           WHERE     GRANTOR = '&3'
          MINUS
          SELECT privilege, grantor, table_name, grantee
            FROM dba_tab_privs@&2
           WHERE GRANTOR = '&1');

PROMPT -- MISSING GRANTS USER
SELECT 'grant '||privilege||' on '||grantor||'.'||table_name||' to '||grantee||';' FROM (
            SELECT privilege, grantor, table_name, grantee
			FROM dba_tab_privs@&2
           WHERE     GRANTEE = '&1'
          MINUS
          SELECT privilege, grantor, table_name, grantee
            FROM dba_tab_privs@&4
           WHERE GRANTEE = '&3');

PROMPT -- SURPLUS GRANTS USER

SELECT 'REVOKE '||privilege||' on '||grantor||'.'||table_name||' FROM '||grantee||';' FROM (
            SELECT privilege, grantor, table_name, grantee
			FROM dba_tab_privs@&4
           WHERE     GRANTEE = '&3'
          MINUS
          SELECT privilege, grantor, table_name, grantee
            FROM dba_tab_privs@&2
           WHERE GRANTEE = '&1');