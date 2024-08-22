#!/bin/bash

# MySQL Server 8.0 に追加データを挿入し、8.4 のデータ領域で動作する MySQL Server 8.0 に追加したデータが伝播しているのを確認
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --sql -e\\"use world;INSERT INTO city VALUES (NULL, 'Tatsuno', 'JPN', 'Hyogo', 77970);\\"
sleep 5
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e\\"use world;SELECT ID,Name,CountryCode,District,Population FROM city WHERE Name='Tatsuno';\\"
