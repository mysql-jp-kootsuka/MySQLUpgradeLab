#!/bin/bash

# MySQL Server 9.0 で、GTID関連変数 (gtid_mode) の状態を確認
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3390 --sql -e"SHOW VARIABLES LIKE '%gtid_mode%';"
