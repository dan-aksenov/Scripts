\set id :scale
\setrandom id 1 1200000

select params->'PARAM3' from jsontable where id = :id;
