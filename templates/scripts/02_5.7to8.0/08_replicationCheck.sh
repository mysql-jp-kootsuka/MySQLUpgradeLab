#!/bin/bash

${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e\\"use world\\;INSERT INTO city VALUES \\(NULL, 'Tatebayashi', 'JPN', 'Gumma', 75440\\)\\;\\"
sleep 1
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e\\"use world\\;SELECT * FROM city WHERE Name='Tatebayashi'\\;\\"