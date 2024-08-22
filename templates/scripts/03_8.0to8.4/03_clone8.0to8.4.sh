#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --sql -e"CLONE INSTANCE FROM root@localhost:3380 IDENTIFIED BY '' DATA DIRECTORY = '${MYSQL_DIR}/data/84/data' REQUIRE SSL;"
