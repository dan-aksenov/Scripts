# Работа с waldump

<https://habr.com/ru/post/685800/>

```bash
/usr/pgsql-13/bin/pg_waldump 00000002000000000000000D | awk '{out=""; for(i=7;i<=NF;i++){if(i>=11&&i<=12) continue; else out=out" "$i}; print out}'| cut -c1-150
```

Вывод. Обнаружение `truncate`

```bash
tx: 511, lsn: 0/0D6F7E20, desc: TRUNCATE nrelids 1 relids 32769

 tx: 511, lsn: 0/0D6F7E50, desc: COMMIT 2022-08-26 13:07:07.027629 +07; rels: base/16384/32769; inval msgs: catcache 50 catcache 49 relcache 32769
```
