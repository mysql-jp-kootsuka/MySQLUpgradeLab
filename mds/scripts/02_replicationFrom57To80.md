# ハンズオン手順2: MySQL Server 5.7 から 8.0 への、データのダンプ/ロードとレプリケーションを通じたアップグレード

## 02-01: MySQL Server 5.7 から 8.0 へのアップグレードの適合性をチェック

MySQL Shell 8.0 を用いて、アップグレードチェッカーを実行します。  
(アップグレードチェッカーに関する情報は[こちら](https://dev.mysql.com/doc/mysql-shell/8.4/en/mysql-shell-utilities-upgrade.html))

実行するスクリプト `./scripts/57/checkUpgradeTo80.sh`:

* checkUpgradeTo80.sh
```
#!/bin/bash

# MySQL Shell 8.0 を用いて、MySQL Server 5.7 から 8.0 へのアップグレードチェックを行う
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357 --js -e"util.checkForServerUpgrade();"
```

```
The MySQL server at localhost:3357, version
5.7.44-enterprise-commercial-advanced - MySQL Enterprise Server - Advanced
Edition (Commercial), will now be checked for compatibility issues for upgrade
to MySQL 8.0.38...

1) Usage of old temporal type
  No issues found

    ......

29) Check for columns that have foreign keys pointing to tables from a diffrent
database engine.
  No issues found

Errors:   0
Warnings: 1
Notices:  1

NOTE: No fatal errors were found that would prevent an upgrade, but some potential issues were detected. Please ensure that the reported issues are not significant before upgrading.
```

アップグレードチェッカーが完了しました。  
Errors 項目がないかを確認してください。Notices, Warnings のみであればアップデート可能です。

## 02-02: MySQL Server 5.7 でGTID (グローバルトランザクション識別子) を有効化

MySQL Server 5.7 でGTID (グローバルトランザクション識別子) を有効化し、バイナリログを出力するようにします。  
GTIDがオンになっていると、レプリケーション設定時に、SOURCE_AUTO_POSITIONオプションでトランザクションの場所が自動指定できます。  
まず、現在のGTIDの設定 (gtid_mode) がオフであることを確認します。

実行するスクリプト `./scripts/57/checkGTIDVar.sh`:

* checkGTIDVar.sh
```
#!/bin/bash

# MySQL Server 5.7 で、GTID関連変数 (gtid_mode) の状態を確認
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHOW VARIABLES LIKE '%gtid_mode%';"
```

| Variable_name | Value |
| ---- | ---- |
|gtid_mode | OFF |

enforce_gtid_consistency、gtid_modeをオンにするために、設定ファイルを差し替えて再起動します。

実行するスクリプト `./scripts/57/stopDB.sh`,`./scripts/57/startDBwGTID.sh`:

* startDBwGTID.sh
```
#!/bin/bash

# MySQL Server 5.7 のデータベース常駐開始 (GTID、バイナリログ出力をオンにした設定ファイル使用)
/home/opc/mysql/57/bin/mysqld --defaults-file=/home/opc/mysql/configs/my57_gtid.cnf &
```

MySQL 設定ファイルの内容 `./configs/my57_gtid.cnf`:

* my57_gtid.cnf
```
[mysqld]
basedir=/home/opc/mysql/57                 # 実行ファイルの存在するフォルダ
datadir=/home/opc/mysql/data/57/data       # DBデータの格納されるフォルダ
port=3357                                  # サーバー待ち受けポート
socket=/tmp/my57.sock
log-error=/home/opc/mysql/data/57/my.error
enforce_gtid_consistency=on                # GTID整合性に違反するトランザクションを禁止する設定
gtid_mode=on                               # GTIDを用いる設定
log_bin=on                                 # バイナリログを出力する設定
server_id=57                               # サーバーごとに一意なID
```

| Variable_name | Value |
| ---- | ---- |
|gtid_mode | ON |

GTID を有効にして MySQL Server 5.7 を再起動し、再度、`./scripts/57/checkGTIDVar.sh`を実行しました。  
gtid_modeがオンになっていることを確認してください。

## 02-03: MySQL Server 5.7 から MySQL Shell 8.0 でデータダンプを実施

実行するスクリプト `./scripts/57/dumpData.sh`:

* dumpData.sh
```
#!/bin/bash

# MySQL Shell 8.0 を用いて、MySQL Server 5.7 のインスタンスダンプを行う
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357 --js -e"util.dumpInstance('/home/opc/mysql/dump/57');"
```

```
NOTE: Backup lock is not supported in MySQL 5.7 and DDL changes will not be blocked. The dump may fail with an error if schema changes are made while dumping.
Acquiring global read lock
Global read lock acquired
Initializing - done
1 out of 5 schemas will be dumped and within them 3 tables, 0 views.
1 out of 3 users will be dumped.
Gathering information - done
All transactions have been started
Global read lock has been released
Writing global DDL files
Writing users DDL
Running data dump using 4 threads.
NOTE: Progress information uses estimated values and may not be accurate.
Writing schema metadata - done
Writing DDL - done
Writing table metadata - done
Starting data dump
100% (5.30K rows / ~5.27K rows), 0.00 rows/s, 0.00 B/s uncompressed, 0.00 B/s compressed
Dump duration: 00:00:00s
Total duration: 00:00:00s
Schemas dumped: 1
Tables dumped: 3
Uncompressed data size: 194.61 KB
Compressed data size: 91.66 KB
Compression ratio: 2.1
Rows written: 5302
Bytes written: 91.66 KB
Average uncompressed throughput: 194.61 KB/s
Average compressed throughput: 91.66 KB/s
```

## 02-04: MySQL Server 8.0 に MySQL Shell 8.0 で接続し、5.7 のデータダンプをロード

実行するスクリプト `./scripts/80/loadDumpFrom57.sh`:

* loadDumpFrom57.sh
```
#!/bin/bash

# MySQL Server 5.7 のダンプデータを MySQL Server 8.0 でロード
# 前回のロードが中途で終わっていてload-progress.*が残っていると、ロードが失敗するので削除
rm /home/opc/mysql/dump/57/load-progress.*
# ignoreVersion オプションは、ダンプとロードの MySQL Server バージョンが異なっていても無視する設定
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --js -e"util.loadDump('/home/opc/mysql/dump/57',{ignoreVersion:true});"
```

```
Loading DDL and Data from '/home/kochi/mysql/dump/57' using 4 threads.
Opening dump...
Target is MySQL 8.0.39-commercial. Dump was produced from MySQL 5.7.44-enterprise-commercial-advanced-log
WARNING: Destination MySQL version is newer than the one where the dump was created. Loading dumps from different major MySQL versions is not fully supported and may not work. The 'ignoreVersion' option is enabled, so loading anyway.
Scanning metadata - done
Checking for pre-existing objects...
Executing common preamble SQL
Executing DDL - done
Executing view DDL - done
Starting data load
Executing common postamble SQL
100% (194.61 KB / 194.61 KB), 0.00 B/s, 3 / 3 tables done
Recreating indexes - done
3 chunks (5.30K rows, 194.61 KB) for 3 tables in 1 schemas were loaded in 0 sec (avg throughput 194.61 KB/s)
0 warnings were reported during the load.
```

## 02-05: MySQL Server 8.0 で、MySQL Server 5.7 をソースとするレプリケーションの設定と開始

MySQL Server 8.0 で MySQL Server 5.7 をソースとするレプリケーションを設定し、開始します。

実行するスクリプト `./scripts/80/setUpReplFrom57.sh`,`./scripts/80/startRepl.sh`:

* setUpReplFrom57.sh
```
#!/bin/bash

# MySQL Server 5.7 をソースとするレプリケーション設定を、レプリカである MySQL Server 8.0 で設定
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"CHANGE REPLICATION SOURCE TO SOURCE_HOST = 'localhost', SOURCE_PORT = 3357, SOURCE_AUTO_POSITION = 1, SOURCE_SSL = 1;"
```

* startRepl.sh
```
#!/bin/bash

# MySQL Server 8.0 でレプリケーションを開始
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"START REPLICA USER='root' PASSWORD='';"
```

## 02-06: レプリケーションの完成をテスト

以上でレプリケーションは完了しました。  
レプリケーションが動作しているか確認するため、MySQL Server 5.7 でデータを更新し、MySQL Server 8.0 に更新が伝播するかを確認します。

実行するスクリプト `./scripts/80/testReplFrom57.sh`:

* testReplFrom57.sh
```
#!/bin/bash

# MySQL Server 5.7 に追加データを挿入し、MySQL Server 8.0 に追加したデータが伝播しているのを確認
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357 --sql -e"use world;INSERT INTO city VALUES (NULL, 'Tatebayashi', 'JPN', 'Gumma', 75440);"
sleep 5
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"use world;SELECT ID,Name,CountryCode,District,Population FROM city WHERE Name='Tatebayashi';"
```

| ID   | Name        | CountryCode | District | Population |
| ---- | ----        | ----        | ----     | ----       |
| 4080 | Tatebayashi | JPN         | Gumma    | 75440      |

検索結果として `Tatebayashi JPN Gumma 75440` が表示されれば正常に動いています。

## 02-07: レプリケーション終了

レプリケーションが最新の更新まで伝播すれば、アプリケーションの接続先を MySQL Server 5.7 から 8.0 に変更し、レプリケーションを終了できます。

実行するスクリプト `./scripts/80/stopRepl.sh`, `./scripts/80/resetRepl.sh`:

* stopRepl.sh
```
#!/bin/bash

# MySQL Server 8.0 でレプリケーションを停止
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"STOP REPLICA FOR CHANNEL '';"
```

* resetRepl.sh
```
#!/bin/bash

# MySQL Server 8.0 でレプリケーションをリセット
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"RESET REPLICA;"
```

以上で、MySQL Server 5.7 から 8.0 へのアップグレードが完了しました。

[次の手順](./03_replicationFrom80To84.md)は、`./scripts/handson/03_replicationFrom80To84.sh` です。
MySQL Server 8.0 から 8.4 への、CLONEプラグインとインプレースアップグレードをテストします。
