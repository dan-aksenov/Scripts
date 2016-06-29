set ver off
spo temp/&1._res.log
CONNECT REPADMIN/REP095@hp01
BEGIN
  DBMS_REPCAT.SUSPEND_MASTER_ACTIVITY(gname => '&1.');
END;
/

spo off
exit