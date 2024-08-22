# ハンズオン手順3: MySQL Server 8.0 から 8.4 への、CLONEプラグインとインプレースアップグレードのテスト

## 02-01: MySQL Server 8.0 から 8.4 へのアップグレードの適合性をチェック

MySQL Shell 8.4 を用いて、アップグレードチェッカーを実行します。

実行するスクリプト `./scripts/80/checkUpgradeTo84.sh`:

* checkUpgradeTo84.sh
```
#!/bin/bash

# MySQL Shell 8.4 を用いて、MySQL Server 8.0 から 8.4 へのアップグレードチェックを行う
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3380 --js -e"util.checkForServerUpgrade();"
```

```
The MySQL server at localhost:3380, version 8.0.39-commercial - MySQL
Enterprise Server - Commercial, will now be checked for compatibility issues
for upgrade to MySQL 8.4.1. To check for a different target server version, use
the targetVersion option.

WARNING: Upgrading MySQL Server from version 8.0.39 to 8.4.1 is not supported.
Please consider running the check using the following option: targetVersion=8.0

1) Removed system variables (removedSysVars)
   No issues found

      ......

12) Checks for partitions by key using columns with prefix key indexes
(partitionsWithPrefixKeys)
   No issues found
Errors:   0
Warnings: 20
Notices:  1

NOTE: No fatal errors were found that would prevent an upgrade, but some potential issues were detected. Please ensure that the reported issues are not significant before upgrading.
```

アップグレードチェッカーが完了しました。  
Errors 項目がないかを確認してください。Notices, Warnings のみであればアップデート可能です。

## 03-02: MySQL Server 8.0 で CLONE プラグインを有効化

CLONE プラグインはプラグインをまず有効にし、必要なシステム変数を設定する必要があります。  
(CLONE プラグインに関する情報は[こちら](https://dev.mysql.com/doc/refman/8.4/en/clone-plugin.html))

実行するスクリプト `./scripts/80/setupClonePlugin.sh`:

* setupClonePlugin.sh
```
#!/bin/bash

# MySQL Server 8.0 で CLONE プラグインを有効にします。
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"INSTALL PLUGIN clone SONAME 'mysql_clone.so';"
sleep 5

# CLONE プラグインが有効になっているのを確かめます。
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'clone';"

# CLONE 元として許されているソースホストを clone_valid_donor_list に定義します。
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SET GLOBAL clone_valid_donor_list = 'localhost:3380';"
```

| PLUGIN_NAME | PLUGIN_STATUS |
| ----        | ----          |
| clone       | ACTIVE        |

## 03-03: MySQL Server 8.0 で CLONE プラグインを実行

MySQL Server 8.0 で CLONE プラグインを実行し、MySQL Server 8.4 用のデータ領域に MySQL のデータ構造をコピーします。  
コピーされたデータは、そこを dataDir に指定することにより MySQL として起動できます。

実行するスクリプト `./scripts/80/cloneTo84.sh`:

* cloneTo84.sh
```
#!/bin/bash

# MySQL Server 8.0 から 8.4 のデータ領域にデータをクローンします。
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"CLONE INSTANCE FROM root@localhost:3380 IDENTIFIED BY '' DATA DIRECTORY = '/home/opc/mysql/data/84/data' REQUIRE SSL;"
```

## 03-04: CLONE したデータ領域を用いて 8.4 へのインプレースアップグレードを実施

MySQL Server 8.0 からコピーしたデータは、MySQL Server 8.0 のデータ形式で保存されています。  
このデータを MySQL Server 8.4 の実行ファイルで起動することにより、データ形式の差は自動で調整され、MySQL Server 8.4として動作します。

このアップデート形式を、インプレースアップグレードといいます。  
インプレースアップグレードは実行ファイルを置き換えるだけであるため、手軽ですが、限られたバージョン間でしか動作しません。  
また不具合を避けるためにも、直接元のデータに置き換えるのではなく、本ハンズオンのように CLONE データやレプリカサーバのデータを対象に行ってください。  
(インプレースアップグレードに関する情報は[こちら](https://dev.mysql.com/doc/refman/8.4/en/upgrade-binary-package.html))

実行するスクリプト `./scripts/84/startDB.sh`:

* startDB.sh
```
#!/bin/bash

# MySQL Server 8.4 のデータベース常駐開始 (GTID=ON)
/home/opc/mysql/84/bin/mysqld --defaults-file=/home/opc/mysql/configs/my84.cnf &
```

MySQL 設定ファイルの内容 `./configs/my84.cnf`:

* my84.cnf
```
[mysqld]
basedir=/home/opc/mysql/84                 # 実行ファイルの存在するフォルダ
datadir=/home/opc/mysql/data/84/data       # DBデータの格納されるフォルダ
port=3384                                  # サーバー待ち受けポート
mysqlx-port=33840
socket=/tmp/my84.sock
mysqlx-socket=/tmp/my84x.socks
log-error=/home/opc/mysql/data/84/my.error
local_infile=on                            # loadDumpでローカルファイルシステムからの読み込みを許可する設定
enforce_gtid_consistency=on                # GTID整合性に違反するトランザクションを禁止する設定
gtid_mode=on                               # GTIDを用いる設定
server_id=84                               # サーバーごとに一意なID
# MySQL 8.0 以上ではバイナリログ出力がデフォルトのため、log_bin=on は不要
```

MySQL 8.4 の起動後は、`./scripts/84/connectDB.sh`で接続、`./scripts/84/stopDB.sh`で停止、`./scripts/84/startDB.sh`で起動できます。

* connectDB.sh
```
#!/bin/bash

# MySQL Server 8.4 への MySQL Shell 接続
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3384
```

* stopDB.sh
```
#!/bin/bash

# MySQL Server 8.4 のデータベース停止
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3384 --sql -e"SHUTDOWN;"
```

* startDB.sh
```
#!/bin/bash

# MySQL Server 8.4 のデータベース常駐開始 (GTID=ON)
/home/opc/mysql/84/bin/mysqld --defaults-file=/home/opc/mysql/configs/my84.cnf &
```

## 03-05: MySQL Server 8.4 で、MySQL Server 8.0 をソースとするレプリケーションの設定と開始

MySQL Server 8.4 で MySQL Server 8.0 をソースとするレプリケーションを設定し、開始します。

実行するスクリプト `./scripts/84/setUpReplFrom80.sh`,`./scripts/84/startRepl.sh`:

* setUpReplFrom80.sh
```
#!/bin/bash

# MySQL Server 8.0 をソースとするレプリケーション設定を、レプリカである MySQL Server 8.4 で設定
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3384 --sql -e"CHANGE REPLICATION SOURCE TO SOURCE_HOST = 'localhost', SOURCE_PORT = 3380, SOURCE_AUTO_POSITION = 1, SOURCE_SSL = 1;"
```

* startRepl.sh
```
#!/bin/bash

# MySQL Server 8.4 でレプリケーションを開始
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3384 --sql -e"START REPLICA USER='root' PASSWORD='';"
```

## 02-06: レプリケーションの完成をテスト

以上でレプリケーションは完了しました。  
レプリケーションが動作しているか確認するため、MySQL Server 8.0 でデータを更新し、MySQL Server 8.4 に更新が伝播するかを確認します。

実行するスクリプト `./scripts/84/testReplFrom80.sh`:

* testReplFrom80.sh
```
#!/bin/bash

# MySQL Server 8.0 に追加データを挿入し、MySQL Server 8.4 に追加したデータが伝播しているのを確認
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3380 --sql -e"use world;INSERT INTO city VALUES (NULL, 'Kashiba', 'JPN', 'Nara', 79020);"
sleep 5
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3384 --sql -e"use world;SELECT ID,Name,CountryCode,District,Population FROM city WHERE Name='Kashiba';"
```

| ID   | Name    | CountryCode | District | Population |
| ---- | ----    | ----        | ----     | ----       |
| 4081 | Kashiba | JPN         | Nara     | 79020      |

検索結果として `Kashiba JPN Nara 79020` が表示されれば正常に動いています。

## 02-07: レプリケーション終了

レプリケーションが最新の更新まで伝播すれば、アプリケーションの接続先を MySQL Server 8.0 から 8.4 に変更して、レプリケーションを終了できます。

実行するスクリプト `./scripts/84/stopRepl.sh`, `./scripts/84/resetRepl.sh`:

* stopRepl.sh
```
#!/bin/bash

# MySQL Server 8.4 でレプリケーションを停止
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3384 --sql -e"STOP REPLICA FOR CHANNEL '';"
```

* resetRepl.sh
```
#!/bin/bash

# MySQL Server 8.4 でレプリケーションをリセット
/home/opc/mysql/84sh/bin/mysqlsh root@localhost:3384 --sql -e"RESET REPLICA;"
```

以上で、MySQL Server 8.0 から 8.4 へのアップグレードが完了しました。

MySQL Server 5.7 => 8.0 => 8.4 アップグレードのハンズオンを完了します。
