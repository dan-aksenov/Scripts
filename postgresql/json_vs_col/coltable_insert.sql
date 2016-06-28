\set id :scale
\setrandom id 1200001 1500000
\set AUTOCOMMIT 0 
BEGIN;
insert into COLTABLE (id,type,dt_create,dt_change,nm_column,PARAM33,PARAM45,PARAM46,PARAM64,PARAM79,PARAM3,PARAM6,PARAM9,PARAM14,PARAM17,PARAM18,PARAM19,PARAM24,PARAM25,PARAM34,PARAM1,PARAM16,PARAM29,PARAM32,PARAM35,PARAM2,PARAM8,PARAM12,PARAM22,PARAM26,PARAM4,PARAM7,PARAM10,PARAM15,PARAM23,PARAM28,PARAM36,PARAM43,PARAM50,PARAM51,PARAM13,PARAM21,PARAM27,PARAM59,PARAM74,PARAM5,PARAM11,PARAM20,PARAM30,PARAM44) select :id as id,1 as TYPE, now() - '2 years'::interval * random() as DT_CREATE, now() - '6 month'::interval * random() as DT_CHANGE,random_string( (random() * 40 + 5)::int4) as NM_COLUMN,random() > 0.5 AS PARAM33,random() > 0.5 AS PARAM45,random() > 0.5 AS PARAM46,random() > 0.5 AS PARAM64,random() > 0.5 AS PARAM79,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM3,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM6,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM9,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM14,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM17,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM18,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM19,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM24,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM25,case when random() > 0.05 then (50 * random() - 10 * random())::integer end AS PARAM34,case when random() < 0.85 then 13573 * random() - 350 * random() end AS PARAM1,case when random() < 0.85 then 13573 * random() - 350 * random() end AS PARAM16,case when random() < 0.85 then 13573 * random() - 350 * random() end AS PARAM29,case when random() < 0.85 then 13573 * random() - 350 * random() end AS PARAM32,case when random() < 0.85 then 13573 * random() - 350 * random() end AS PARAM35,case when random() > 0.2 then (now() - interval '8 years' * random() + interval '1 year' * random())::date end AS PARAM2,case when random() > 0.2 then (now() - interval '8 years' * random() + interval '1 year' * random())::date end AS PARAM8,case when random() > 0.2 then (now() - interval '8 years' * random() + interval '1 year' * random())::date end AS PARAM12,case when random() > 0.2 then (now() - interval '8 years' * random() + interval '1 year' * random())::date end AS PARAM22,case when random() > 0.2 then (now() - interval '8 years' * random() + interval '1 year' * random())::date end AS PARAM26,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM4,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM7,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM10,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM15,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM23,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM28,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM36,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM43,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM50,case when random() > 0.15 then random_string( (random() * 150 + 10)::int4) end AS PARAM51,case when random() > 0.2 then random_string( (random() * 5000)::int4) end AS PARAM13,case when random() > 0.2 then random_string( (random() * 5000)::int4) end AS PARAM21,case when random() > 0.2 then random_string( (random() * 5000)::int4) end AS PARAM27,case when random() > 0.2 then random_string( (random() * 5000)::int4) end AS PARAM59,case when random() > 0.2 then random_string( (random() * 5000)::int4) end AS PARAM74,(select coalesce(array_agg((random() * 50 - random() * 5)::integer)::integer[], ARRAY[]::integer[]) from generate_series(1,(random() * 15)::integer)) AS PARAM5,(select coalesce(array_agg((random() * 50 - random() * 5)::integer)::integer[], ARRAY[]::integer[]) from generate_series(1,(random() * 15)::integer)) AS PARAM11,(select coalesce(array_agg((random() * 50 - random() * 5)::integer)::integer[], ARRAY[]::integer[]) from generate_series(1,(random() * 15)::integer)) AS PARAM20,(select coalesce(array_agg((random() * 50 - random() * 5)::integer)::integer[], ARRAY[]::integer[]) from generate_series(1,(random() * 15)::integer)) AS PARAM30,(select coalesce(array_agg((random() * 50 - random() * 5)::integer)::integer[], ARRAY[]::integer[]) from generate_series(1,(random() * 15)::integer)) AS PARAM44;
ROLLBACK;
END;
