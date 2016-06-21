crosscheck backup;
crosscheck archivelog all;
BACKUP INCREMENTAL LEVEL 0 AS COMPRESSED BACKUPSET DATABASE PLUS ARCHIVELOG DELETE INPUT;
delete obsolete;
exit;