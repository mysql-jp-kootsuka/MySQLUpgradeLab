#!/bin/bash

# MySQL Server 9.0 のデータベース常駐開始 (GTID=ON)
${MYSQL_DIR}/90/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my90.cnf &
