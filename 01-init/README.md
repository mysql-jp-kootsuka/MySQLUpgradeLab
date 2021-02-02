# Initialize Database for my1.cnf my2.cnf and my3.cnf
#
# This is to initialize mysql data directory
# 01-init3310.sh for 3310
# 02-init3320.sh for 3320
# 03-init3330.sh for 3330
#
# It is --initialize-insecure
# root has no password


```
/usr/local/mysql/bin/mysqld --defaults-file=config/my1.cnf --initialize-insecure
/usr/local/mysql/bin/mysqld --defaults-file=config/my2.cnf --initialize-insecure
/usr/local/mysql/bin/mysqld --defaults-file=config/my3.cnf --initialize-insecure
```
