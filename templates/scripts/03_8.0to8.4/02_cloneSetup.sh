#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --sql -e"INSTALL PLUGIN clone SONAME 'mysql_clone.so';" 
sleep 1
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --sql -e"SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'clone';"
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --sql -e"SET GLOBAL clone_valid_donor_list = 'localhost:3380';"
