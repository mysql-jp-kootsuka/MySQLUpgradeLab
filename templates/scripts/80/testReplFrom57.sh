#!/bin/bash

# MySQL Server 5.7 に追加データを挿入し、MySQL Server 8.0 に追加したデータが伝播しているのを確認
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e"use world;INSERT INTO city VALUES (NULL, 'Tatebayashi', 'JPN', 'Gumma', 75440);"
sleep 5
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"use world;SELECT ID,Name,CountryCode,District,Population FROM city WHERE Name='Tatebayashi';"
