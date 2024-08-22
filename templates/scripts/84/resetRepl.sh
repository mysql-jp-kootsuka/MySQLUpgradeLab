#!/bin/bash

# MySQL Server 8.4 でレプリケーションをリセット
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"RESET REPLICA;"
