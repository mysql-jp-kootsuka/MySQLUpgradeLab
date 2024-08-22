#!/bin/bash

# MySQL Server 9.0 のデータベース停止
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3390 --sql -e"SHUTDOWN;"
