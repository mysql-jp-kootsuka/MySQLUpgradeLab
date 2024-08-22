#!/bin/bash

# MySQL Server 8.0 でレプリケーションの状況を確認
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SHOW REPLICA STATUS\G"
