#!/bin/bash

# MySQL Server 5.7 のデータベース停止
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHUTDOWN;"
