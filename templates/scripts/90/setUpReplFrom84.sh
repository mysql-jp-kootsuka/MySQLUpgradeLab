#!/bin/bash

# MySQL Server 8.4 をソースとするレプリケーション設定を、レプリカである MySQL Server 9.0 で設定
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3390 --sql -e"CHANGE REPLICATION SOURCE TO SOURCE_HOST = 'localhost', SOURCE_PORT = 3384, SOURCE_AUTO_POSITION = 1, SOURCE_SSL = 1;"
