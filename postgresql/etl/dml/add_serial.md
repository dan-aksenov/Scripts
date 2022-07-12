# How to add serial to existing column in Postgres

```sql
SELECT MAX(column_name) + 1 FROM table_name; -- for example max=999
CREATE SEQUENCE table_name_column_name_seq START WITH 999; -- replace 999 with max above
ALTER TABLE table_name ALTER COLUMN column_name SET DEFAULT nextval('table_name_column_name_seq');
```

<https://gist.github.com/oleglomako/185df689706c5499612a0d54d3ffe856>
