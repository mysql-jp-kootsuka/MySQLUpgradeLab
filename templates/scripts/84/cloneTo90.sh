#!/bin/bash

# MySQL Server 8.4 から 9.0 のデータ領域にデータをクローンします。
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"CLONE INSTANCE FROM root@localhost:3384 IDENTIFIED BY '' DATA DIRECTORY = '${MYSQL_DIR}/data/90/data' REQUIRE SSL;"
