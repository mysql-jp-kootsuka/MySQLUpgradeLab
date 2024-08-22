#!/bin/bash

# MySQL Server 5.7 のデータベース常駐開始 (GTID、バイナリログ出力をオンにした設定ファイル使用)
${MYSQL_DIR}/57/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my57_gtid.cnf &
