# This lab is to backup innodb cluster using MySQL Enterprise Backup
## URL : https://dev.mysql.com/doc/mysql-enterprise-backup/8.0/en/mysqlbackup.privileges.html
1. Creating backup user
2. Execute MySQL Backup on 3310 (RW)


## Creating backup user "mysqlbackup".   On the manual, it is 'localhost'.  For MySQLL InnoDB Cluster backup, you can rename the user with host part to '%'

  * Creating 'mysqlbackup' user 
```
mysql -uroot -h127.0.0.1 -P3310 << EOL
DROP USER if exists 'mysqlbackup'@'localhost';
DROP USER if exists 'mysqlbackup'@'%';
CREATE USER 'mysqlbackup'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, BACKUP_ADMIN, RELOAD, PROCESS, SUPER, REPLICATION CLIENT ON *.* TO 'mysqlbackup'@'localhost';
GRANT CREATE, INSERT, DROP, UPDATE ON mysql.backup_progress TO 'mysqlbackup'@'localhost'; 
GRANT CREATE, INSERT, DROP, UPDATE, SELECT, ALTER ON mysql.backup_history TO 'mysqlbackup'@'localhost';
GRANT LOCK TABLES, CREATE, DROP, FILE ON *.* TO 'mysqlbackup'@'localhost';
GRANT CREATE, INSERT, DROP, UPDATE ON mysql.backup_sbt_history TO 'mysqlbackup'@'localhost';
GRANT ENCRYPTION_KEY_ADMIN ON *.* TO 'mysqlbackup'@'localhost';
GRANT INNODB_REDO_LOG_ARCHIVE ON *.* TO 'mysqlbackup'@'localhost';
rename user 'mysqlbackup'@'localhost' to 'mysqlbackup'@'%';
EOL
```

## Executing MySQL Enterprise Backup on 3310 (RW node)
  * Switching folder to 
```
cd ~/lab/InnoDBClusterLab/08-backup
```

  * Full backup as FOLDER
```
time mysqlbackup --port=3310 --host=127.0.0.1 --protocol=tcp --user=mysqlbackup --password=password  --backup-dir=.  --with-timestamp backup
```

  * Full backup as FOLDER and apply log
```
time mysqlbackup --port=3310 --host=127.0.0.1 --protocol=tcp --user=mysqlbackup --password=password  --backup-dir=.  --with-timestamp backup-and-apply-log
```

  * Full backup as IMAGE and apply log
```
time mysqlbackup --port=3310 --host=127.0.0.1 --protocol=tcp --user=mysqlbackup --password=password  --backup-dir=. --backup-image=image3310.img --with-timestamp backup-to-image
```
  * Do one more time Full backup as FOLDER and apply log - For Restore process
```
time mysqlbackup --port=3310 --host=127.0.0.1 --protocol=tcp --user=mysqlbackup --password=password  --backup-dir=.  --with-timestamp backup-and-apply-log
```


  * Incremental backup as FODER 
```
time mysqlbackup --port=3310 --host=127.0.0.1 --protocol=tcp --user=mysqlbackup --password=password  --backup-dir=. --incremental-base=history:last_backup --incremental-backup-dir=./incr --with-timestamp --incremental backup
```

## Checking mysql backup table

  * login to any nodes (e.g. 3310)
```
mysql -uroot -h127.0.0.1 -P3310
```
  
  * Executing the Queries
```
select * from mysql.backup_history;
select * from mysql.backup_progress;
show create table mysql.backup_history\G
show create table mysql.backup_progress\G
```

## Shutdown 3310 and clean up the data folder
```
mysql -uroot -h127.0.0.1 -P3310 -e "shutdown;"

rm -rf ~/data/3310
```

## Identify the latest full backup folder with timestamp
  * Switching to the backup folder
```
cd ~/lab/InnoDBClusterLab/08-backup
ls -t1d 2021*|sed -n '1p'
time mysqlbackup --defaults-file=../config/my1.cnf --backup-dir=`ls -t1d 2021*|sed -n '1p'` copy-back-and-apply-log
```

  * Switching to the restored 3310 data folder and Rename the backup cnf to get server_uuid and presisted variables restored.
```
cd ~/data/3310
ls -l *.cnf
mv backup-auto.cnf auto.cnf
mv backup-mysqld-auto.cnf mysqld-auto.cnf
```

## Startup MySQL node (3310)
  * Switching back to Lab folder
```
cd ~/lab/InnoDBClusterLab
/usr/local/mysql/bin/mysqld_safe --defaults-file=config/my1.cnf &
```


## Using MySQL Shell to valid MySQL InnoDB Cluster status
  * Login with MySQL Shell
```
mysqlsh --uri gradmin:grpass@workshop8:3320
```

  * Checking the InnoDB Cluster Status
```
var x = dba.getCluster()
x.status()
```




