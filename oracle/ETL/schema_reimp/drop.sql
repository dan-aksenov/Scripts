spo .\log\&1._drop.log
DECLARE
  l_cnt integer;
BEGIN
  EXECUTE IMMEDIATE 'alter user &1. account lock';
  FOR x IN (SELECT *
              FROM v$session
             WHERE username = '&1')
  LOOP

--look http://www.pythian.com/blog/alter-session-kill-on-steroids/
EXECUTE IMMEDIATE 'alter system kill session ''' || x.sid || ',' || x.serial# || ''' IMMEDIATE';

--EXECUTE IMMEDIATE 'alter system disconnect session ''' || x.sid || ',' || x.serial# || ''' IMMEDIATE';
END LOOP;

  -- Wait for as long as it takes for all the sessions to go away
  LOOP
    SELECT COUNT(*)
      INTO l_cnt
      FROM v$session
     WHERE username = '&1.';
    EXIT WHEN l_cnt = 0;
    dbms_lock.sleep( 10 );
  END LOOP;

  EXECUTE IMMEDIATE 'drop user &1. cascade';
END;
/
spo off
exit