set ver off
spo temp/&1._res.log
CONNECT REPADMIN/REP095@hp01
BEGIN
  DBMS_REPCAT.RESUME_MASTER_ACTIVITY('&1.',FALSE);
END;
/

spo off
exit