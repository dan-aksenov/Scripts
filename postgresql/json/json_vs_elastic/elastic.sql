\set id :scale
\setrandom id 6 36
SELECT vl_data->'id_tu' FROM test_json WHERE zdb('test_json', ctid) ==> 'vl_data.id_tu=:id';