#!/bin/bash

# MySQL Server 9.0 でレプリケーションを開始
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3390 --sql -e"START REPLICA USER='root' PASSWORD='';"
