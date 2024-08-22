#!/bin/bash

# MySQL Server 5.7 のデータベースデータ初期化 (GTID、バイナリログ出力はデフォルト=OFF)
${MYSQL_DIR}/57/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my57.cnf --initialize-insecure
