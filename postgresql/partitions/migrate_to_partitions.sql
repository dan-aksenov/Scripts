--Миграция в партицированные таблицы для версии 10+ 
--https://www.depesz.com/2019/03/19/migrating-simple-table-to-partitioned-how/  
 
begin; 

alter table pgbench_history rename to pgbench_history_old; 
create table pgbench_history (like pgbench_history_old) partition by range(mtime); 
alter table pgbench_history attach partition pgbench_history_old default; 

create table pgbench_history_20200713 (like pgbench_history_old including ALL); 
with x as ( 
delete from pgbench_history_old where mtime between '2020-07-13 00:00:00' and '2020-07-13 23:59:59' 
returning *) 
insert into pgbench_history_20200713 select * from x; 

alter table pgbench_history  
attach partition pgbench_history_20200713  
for values from ('2020-07-13 00:00:00') to ('2020-07-13 23:59:59'); 

commit; 

 



 