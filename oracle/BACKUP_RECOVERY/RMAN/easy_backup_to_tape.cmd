run {
allocate channel ch01 type sbt_tape;
BACKUP INCREMENTAL LEVEL 0 AS COMPRESSED BACKUPSET DATABASE PLUS ARCHIVELOG;
release channel ch01;
}