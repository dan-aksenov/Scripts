\set type :scale
\set param :scale
\setrandom param 1 999999
--\setrandom type 1 4

select params->'PARAM3' from jsontable where params->'PARAM3' = ':param';

