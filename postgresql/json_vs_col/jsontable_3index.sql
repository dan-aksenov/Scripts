\set param1 :scale
\set param2 :scale
\setrandom param1 1 999999
\setrandom param2 1 999999

select params->'PARAM19' from jsontable where params->'PARAM3' = ':param1' and params->'PARAM19' = ':param2' and type = 1;
