#!/bin/bash

# MySQL Server 8.0 から 8.4 のデータ領域にデータをクローンします。
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"CLONE INSTANCE FROM root@localhost:3380 IDENTIFIED BY '' DATA DIRECTORY = '${MYSQL_DIR}/data/84/data' REQUIRE SSL;"
