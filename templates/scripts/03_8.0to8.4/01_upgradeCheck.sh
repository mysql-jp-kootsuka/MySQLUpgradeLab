#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --js -e\\"util.checkForServerUpgrade();\\"
