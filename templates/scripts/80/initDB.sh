#!/bin/bash

# MySQL Server 8.0 のデータベースデータ初期化 (GTID=ON)
${MYSQL_DIR}/80/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my80.cnf --initialize-insecure
