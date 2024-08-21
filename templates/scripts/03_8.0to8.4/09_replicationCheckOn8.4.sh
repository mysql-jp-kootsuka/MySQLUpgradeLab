#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --sql -e\\"use world\\;INSERT INTO city VALUES \\(NULL, \\'Kashiba\\', \\'JPN\\', \\'Nara\\', 79020\\)\\;\\"
sleep 1
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e\\"use world\\;SELECT \\* FROM city WHERE Name=\\'Kashiba\\'\\;\\"
