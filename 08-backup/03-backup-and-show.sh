. ./comm.sh
time mysqlbackup --port=3310 --host=127.0.0.1 --protocol=tcp --user=mysqlbackup --password=password  --backup-dir=.  --with-timestamp backup-and-apply-log


#  * Incremental backup as FODER 
time mysqlbackup --port=3310 --host=127.0.0.1 --protocol=tcp --user=mysqlbackup --password=password  --backup-dir=. --incremental-base=history:last_backup --incremental-backup-dir=./incr --with-timestamp --incremental backup

## Checking mysql backup table

mysql -t -uroot -h127.0.0.1 -P3310 << EOL
  
select * from mysql.backup_history;
select * from mysql.backup_progress;
show create table mysql.backup_history\G
show create table mysql.backup_progress\G

EOL
