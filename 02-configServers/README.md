# Configure my1.cnf my2.cnf and my3.cnf
## to allow replication and gtid
##

1. Append the following config to [my1.cnf, my2.cnf, my3.cnf]

```
# setup binlog and relaylog
log-bin=logbin
relay-log=logrelay
binlog-format=row

# Table based repositories
master-info-repository=TABLE
relay-log-info-repository=TABLE

# enable gtid
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=true


# Extraction Algorithm
transaction-write-set-extraction=XXHASH64
report-host=<your hostname>
```

2. Startup mysql server

```
 /usr/local/mysql/bin/mysqld --defaults-file=config/my1.cnf &
 /usr/local/mysql/bin/mysqld --defaults-file=config/my2.cnf &
 /usr/local/mysql/bin/mysqld --defaults-file=config/my3.cnf &
```

3. Check if they are all running 

```
 /usr/local/mysql/bin/mysql -uroot -h127.0.0.1 -P3310 -e "select @@hostname, @@port;"
 /usr/local/mysql/bin/mysql -uroot -h127.0.0.1 -P3320 -e "select @@hostname, @@port;"
 /usr/local/mysql/bin/mysql -uroot -h127.0.0.1 -P3330 -e "select @@hostname, @@port;"


