#!/bin/bash

# MySQL Server 8.4 で、GTID関連変数 (gtid_mode) の状態を確認
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"SHOW VARIABLES LIKE '%gtid_mode%';"
