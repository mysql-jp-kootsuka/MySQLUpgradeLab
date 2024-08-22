#!/bin/bash

# MySQL Server 9.0 でレプリケーションの状況を確認
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3390 --sql -e"SHOW REPLICA STATUS\G"
