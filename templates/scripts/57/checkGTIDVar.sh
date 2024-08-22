#!/bin/bash

# MySQL Server 5.7 で、GTID関連変数 (gtid_mode) の状態を確認
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHOW VARIABLES LIKE '%gtid_mode%';"
