#!/bin/bash

# MySQL Server 8.4 でレプリケーションを停止
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"STOP REPLICA FOR CHANNEL '';"
