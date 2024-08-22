#!/bin/bash

# MySQL Server 8.0 で CLONE プラグインを有効にします。
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"INSTALL PLUGIN clone SONAME 'mysql_clone.so';" 
sleep 5

# CLONE プラグインが有効になっているのを確かめます。
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'clone';"

# CLONE 元として許されているソースホストを clone_valid_donor_list に定義します。
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SET GLOBAL clone_valid_donor_list = 'localhost:3380';"
