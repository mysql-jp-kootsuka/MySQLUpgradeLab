#!/bin/bash

# MySQL Server 9.0 でレプリケーションをリセット
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3390 --sql -e"RESET REPLICA;"
