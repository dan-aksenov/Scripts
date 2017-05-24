set FEED OFF
set pagesize 0

select owner,sum(bytes)/1024/1024 Mb from dba_segments group by owner order by 2 desc