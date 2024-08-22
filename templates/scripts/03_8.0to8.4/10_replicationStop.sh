#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"STOP REPLICA FOR CHANNEL '';RESET REPLICA;"
