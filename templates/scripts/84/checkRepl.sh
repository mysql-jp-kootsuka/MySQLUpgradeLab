#!/bin/bash

# MySQL Server 8.4 でレプリケーションの状況を確認
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"SHOW REPLICA STATUS\G"
