#!/bin/bash

# MySQL Server 8.0 で、GTID関連変数 (gtid_mode) の状態を確認
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SHOW VARIABLES LIKE '%gtid_mode%';"
