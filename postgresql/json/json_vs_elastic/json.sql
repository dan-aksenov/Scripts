\set id :scale
\setrandom id 6 36
select vl_data ->'id_tu' from test_json2 where vl_data ->'id_tu' = ':id';
