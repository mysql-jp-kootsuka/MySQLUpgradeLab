#!/bin/bash

${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHUTDOWN;"
sleep 1
${MYSQL_DIR}/57/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my57_gtid.cnf &
