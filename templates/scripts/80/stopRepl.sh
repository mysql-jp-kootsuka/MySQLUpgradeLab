#!/bin/bash

# MySQL Server 8.0 でレプリケーションを停止
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"STOP REPLICA FOR CHANNEL '';"
