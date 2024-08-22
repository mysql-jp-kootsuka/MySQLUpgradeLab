#!/bin/bash

# MySQL Server 8.0 でレプリケーションをリセット
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"RESET REPLICA;"
