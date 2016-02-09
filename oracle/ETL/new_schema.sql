/* Creates new schema by cloning existing one whithout data.
*/
set serveroutput on
host impdp dbax/dbax@&3. network_link=&3. schemas=&1._100 remap_schema=&1._100:&1._&2. content=metadata_only transform=oid:n exclude=STATISTICS logfile=new_schema_&1._&2.

exec dbms_stats.unlock_schema_stats('&1._&2.');

exec dbms_stats.gather_schema_stats(ownname => '&1._&2.');