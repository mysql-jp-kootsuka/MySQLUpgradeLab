#!/bin/bash

# MySQL Server 9.0 でレプリケーションを停止
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3390 --sql -e"STOP REPLICA FOR CHANNEL '';"
