. ./scripts/commons/functions.sh

cat << STEP3_1
# ハンズオン手順3: MySQL Server 8.0 から 8.4 への、CLONEプラグインとインプレースアップグレードのテスト

## 03-01: MySQL Server 8.0 から 8.4 へのアップグレードの適合性をチェック

MySQL Shell 8.4 を用いて、アップグレードチェッカーを実行します。

実行するスクリプト \`./scripts/80/checkUpgradeTo84.sh\`:
STEP3_1

extractFile "scripts/80/checkUpgradeTo84.sh"

waitRun

runAndTrapError "scripts/80/checkUpgradeTo84.sh"

cat << STEP3_2
アップグレードチェッカーが完了しました。
Errors 項目がないかを確認してください。Notices, Warnings のみであればアップデート可能です。


STEP3_2

sleep 4

cat << STEP3_3
## 03-02: MySQL Server 8.0 で CLONE プラグインを有効化

CLONE プラグインはプラグインをまず有効にし、必要なシステム変数を設定する必要があります。
(CLONE プラグインに関する情報は: https://dev.mysql.com/doc/refman/8.4/en/clone-plugin.html)

実行するスクリプト \`./scripts/80/setupClonePlugin.sh\`:
STEP3_3

extractFile "scripts/80/setupClonePlugin.sh"

waitRun

runAndTrapError "scripts/80/setupClonePlugin.sh"

sleep 4

cat << STEP3_4
## 03-03: MySQL Server 8.0 で CLONE プラグインを実行

MySQL Server 8.0 で CLONE プラグインを実行し、MySQL Server 8.4 用のデータ領域に MySQL のデータ構造をコピーします。
コピーされたデータは、そこを dataDir に指定することにより MySQL として起動できます。

実行するスクリプト \`./scripts/80/cloneTo84.sh\`:
STEP3_4

extractFile "scripts/80/cloneTo84.sh"

waitRun

runAndTrapError "scripts/80/cloneTo84.sh"

sleep 4

cat << STEP3_5
## 03-04: CLONE したデータ領域を用いて 8.4 へのインプレースアップグレードを実施

MySQL Server 8.0 からコピーしたデータは、MySQL Server 8.0 のデータ形式で保存されています。
このデータを MySQL Server 8.4 の実行ファイルで起動することにより、データ形式の差は自動で調整され、MySQL Server 8.4として動作します。

このアップデート形式を、インプレースアップグレードといいます。
インプレースアップグレードは実行ファイルを置き換えるだけであるため、手軽ですが、限られたバージョン間でしか動作しません。
また不具合を避けるためにも、直接元のデータに置き換えるのではなく、本ハンズオンのように CLONE データやレプリカサーバのデータを対象に行ってください。
(インプレースアップグレードに関する情報は: https://dev.mysql.com/doc/refman/8.4/en/upgrade-binary-package.html)

実行するスクリプト \`./scripts/84/startDB.sh\`:
STEP3_5

extractFile "scripts/84/startDB.sh"

cat << STEP3_6
MySQL 設定ファイルの内容 \`./configs/my84.cnf\`:
STEP3_6

extractFile "configs/my84.cnf"

waitRun

runAndTrapError "scripts/84/startDB.sh"

cat << STEP3_7
MySQL 8.4 の起動後は、\`./scripts/84/connectDB.sh\`で接続、\`./scripts/84/stopDB.sh\`で停止、\`./scripts/84/startDB.sh\`で起動できます。
STEP3_7

extractFile "scripts/84/connectDB.sh"
extractFile "scripts/84/stopDB.sh"
extractFile "scripts/84/startDB.sh"

sleep 4

cat << STEP3_8
## 03-05: MySQL Server 8.4 で、MySQL Server 8.0 をソースとするレプリケーションの設定と開始

MySQL Server 8.4 で MySQL Server 8.0 をソースとするレプリケーションを設定し、開始します。

実行するスクリプト \`./scripts/84/setUpReplFrom80.sh\`,\`./scripts/84/startRepl.sh\`:
STEP3_8

extractFile "scripts/84/setUpReplFrom80.sh"
extractFile "scripts/84/startRepl.sh"

waitRun

runAndTrapError "scripts/84/setUpReplFrom80.sh"
runAndTrapError "scripts/84/startRepl.sh"

sleep 4

cat << STEP3_9
## 03-06: レプリケーションの完成をテスト

以上でレプリケーションは完了しました。
レプリケーションが動作しているか確認するため、MySQL Server 8.0 でデータを更新し、MySQL Server 8.4 に更新が伝播するかを確認します。

実行するスクリプト \`./scripts/84/testReplFrom80.sh\`:
STEP3_9

extractFile "scripts/84/testReplFrom80.sh"

waitRun

runAndTrapError "scripts/84/testReplFrom80.sh"

cat << STEP3_10
検索結果として \`Kashiba JPN Nara 79020\` が表示されれば正常に動いています。

STEP3_10

sleep 4

cat << STEP3_11
## 03-07: レプリケーション終了

レプリケーションが最新の更新まで伝播すれば、アプリケーションの接続先を MySQL Server 8.0 から 8.4 に変更して、レプリケーションを終了できます。

実行するスクリプト \`./scripts/84/stopRepl.sh\`, \`./scripts/84/resetRepl.sh\`:
STEP3_11

extractFile "scripts/84/stopRepl.sh"
extractFile "scripts/84/resetRepl.sh"

waitRun

runAndTrapError "scripts/84/stopRepl.sh"
runAndTrapError "scripts/84/resetRepl.sh"

cat << STEP3_12
以上で、MySQL Server 8.0 から 8.4 へのアップグレードが完了しました。

MySQL Server 5.7 => 8.0 => 8.4 アップグレードのハンズオンを完了します。
STEP3_12

exit 0
