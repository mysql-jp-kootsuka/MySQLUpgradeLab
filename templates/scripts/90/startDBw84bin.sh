#!/bin/bash

# 9.0向けのデータ配置ヵ所のデータを、MySQL Server 8.4 のバイナリで起動し常駐開始
# 停止後、同じデータを MySQL Server 9.0 で再度起動すると、8.4 => 9.0 のインプレースアップグレードのテストが行える 
${MYSQL_DIR}/84/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my84_clone.cnf &
