--tables count
select sname,count(*) from dba_repobject@HP01
where  oname not like '%$%' and GENERATION_STATUS='GENERATED'  and sname in (select gname from dba_repsites@HP01 where masterdef='Y' and dblink='HP01')
group by sname
having count(*)<>123 
order by 1

--conflicts count
select sname,count(*) from dba_repconflict@hp01
where sname in (select gname from dba_repsites@HP01 where masterdef='Y' and dblink='HP01')
group by sname
having count(*)<>151
order by 1

--sites count
select distinct
    t1.gname,
    case
       when t2.dblink is not null then 1
       else 0
    end MES,
    case
       when t3.dblink is not null then 1
       else 0
    end GL,
    case
       when t4.dblink is not null then 1
       else 0
    end BYT
from dba_repsites@hp01 t1
inner join dba_repsites@HP01 t0
on t0.masterdef='Y' and t0.dblink='HP01' and t0.gname=t1.gname
left join  dba_repsites@hp01 t2
on t0.gname=t2.gname and t2.dblink like 'MES_%'
left join  dba_repsites@hp01 t3
on t0.gname=t3.gname and t3.dblink='GL'
left join  dba_repsites@hp01 t4
on t0.gname=t4.gname and t4.dblink='BYT'
where t2.dblink is null or t4.dblink is null  or t3.dblink is null
order by 1

--errors
select sname,oname,REPLICATION_TRIGGER_EXISTS,INTERNAL_PACKAGE_EXISTS
from dba_repobject@BYT 
where (REPLICATION_TRIGGER_EXISTS='N' or INTERNAL_PACKAGE_EXISTS='N') and sname in  (select gname from dba_repsites@HP01 where masterdef='Y' and dblink='HP01') 
order by sname;
