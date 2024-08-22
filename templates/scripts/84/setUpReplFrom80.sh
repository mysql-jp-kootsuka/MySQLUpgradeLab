#!/bin/bash

# MySQL Server 8.0 をソースとするレプリケーション設定を、レプリカである MySQL Server 8.4 で設定
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"CHANGE REPLICATION SOURCE TO SOURCE_HOST = 'localhost', SOURCE_PORT = 3380, SOURCE_AUTO_POSITION = 1, SOURCE_SSL = 1;"
