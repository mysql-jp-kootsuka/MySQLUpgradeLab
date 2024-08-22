#!/bin/bash

# MySQL Server 8.0 のダンプデータを MySQL Server 8.4 でロード
# 前回のロードが中途で終わっていてload-progress.*が残っていると、ロードが失敗するので削除
rm ${MYSQL_DIR}/dump/80/load-progress.*
# ignoreVersion オプションは、ダンプとロードの MySQL Server バージョンが異なっていても無視する設定
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --js -e"util.loadDump('${MYSQL_DIR}/dump/80',{ignoreVersion:true});"
