/* Formatted on 16.04.2015 13:06:38 (QP5 v5.256.13226.35538) */
CONN username/password@&2
SET VER OFF 
SET LINES 500
SET FEED OFF
SET TRIMS ON
SET PAGES 0

SPO .\temp\ddl_&1._&2._&3._&4..sql
PROMPT -- &1 on &2 compare with &3 on &4

SELECT 'conn username/password@&4' FROM DUAL;

PROMPT --ALL OBJECTS DIFF

@scripts\objects

PROMPT --INDEXES

@scripts\indexes

PROMPT --TABLES

@scripts\tables

PROMPT --PARTITIONS

@scripts\partitions

PROMPT --CONSTRAINTS

@scripts\constraints

PROMPT --COLUMNS
@scripts\columns

--PROMPT --GRANTS

--@scripts\grants

PROMPT --END DDL COMPARISSON SCRIPT

SPO OFF
EXIT
