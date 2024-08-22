#!/bin/bash

# MySQL Server 8.4 のデータベースデータ初期化 (GTID=ON)
${MYSQL_DIR}/84/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my84.cnf --initialize-insecure
