#!/bin/bash

# MySQL Server 8.0 に追加データを挿入し、MySQL Server 8.4 に追加したデータが伝播しているのを確認
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --sql -e"use world;INSERT INTO city VALUES (NULL, 'Kashiba', 'JPN', 'Nara', 79020);"
sleep 5
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"use world;SELECT ID,Name,CountryCode,District,Population FROM city WHERE Name='Kashiba';"
