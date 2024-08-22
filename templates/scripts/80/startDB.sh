#!/bin/bash

# MySQL Server 8.0 のデータベース常駐開始 (GTID=ON)
${MYSQL_DIR}/80/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my80.cnf &
