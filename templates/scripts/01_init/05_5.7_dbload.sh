#!/bin/bash

${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e"source ${MYSQL_DIR}/sql/world.sql;"
