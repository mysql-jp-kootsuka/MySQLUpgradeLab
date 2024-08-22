#!/bin/bash

# 8.4向けのデータ配置ヵ所のデータを、MySQL Server 8.0 のバイナリで起動し常駐開始
# 停止後、同じデータを MySQL Server 8.4 で再度起動すると、8.0 => 8.4 のインプレースアップグレードのテストが行える 
${MYSQL_DIR}/80/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my80_clone.cnf &
