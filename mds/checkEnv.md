# 環境確認

[環境構築](./extractScripts/extractEnv.md)で構築される環境([ハンズオンワークショップ](https://eventreg.oracle.com/profile/web/index.cfm?PKwebID=0x883786abcd&source=DEVT240718P00002:ex:pev:::::&SC=:ex:pev:::::&pcode=DEVT240718P00002)の場合は提供されるコンピュートインスタンス)は、以下のような構成になっています。

## 接続

自分の環境にハンズオン環境を構築された場合は、それに従い接続してください。    
ワークショップでは、参加者に接続先（各人1台提供）、接続用秘密鍵を別途提供しますので、それを用いて接続してください。  

### 接続例

SSHでIPアドレス`123.45.67.89`に接続、秘密鍵が`~/.ssh/handson_user1.key`の場合: (ユーザ名は`opc`)

```
$ ssh -i ~/.ssh/handson_user1.key opc@123.45.67.89
The authenticity of host '123.45.67.89 (123.45.67.89)' can't be established.
ED25519 key fingerprint is SHA256:ABCDEFGHIJKLMNO/abcdefghijklmno/12345678910.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '123.45.67.89' (ED25519) to the list of known hosts.
Last login: Mon Aug 19 01:33:39 2024 from 234.56.78.91
[opc@handson-user1 ~]$
```

### 注意

* SSH、Puttyなど接続クライアントは各自ご用意ください。
* インスタンスはワークショップ終了後削除いたします。

## 環境説明

提供される環境は、ハンズオンのルートディレクトリ (ワークショップでは`/home/opc/mysql`) を`$MYSQL_DIR`として、以下のようになります。

+ `$MYSQL_DIR` #ハンズオンのルートディレクトリ
  + `57`       [#MySQLバイナリフォルダ](#MySQLバイナリフォルダ)
  + `80`       [#MySQLバイナリフォルダ](#MySQLバイナリフォルダ)
  + `80sh`     [#mysql-shellバイナリフォルダ](#mysql-shellバイナリフォルダ)
  + `84`       [#MySQLバイナリフォルダ](#MySQLバイナリフォルダ)
  + `84sh`     [#mysql-shellバイナリフォルダ](#mysql-shellバイナリフォルダ)
  + `90`       [#MySQLバイナリフォルダ](#MySQLバイナリフォルダ)
  + `90sh`     [#mysql-shellバイナリフォルダ](#mysql-shellバイナリフォルダ)
  + `configs`  [#mysql設定ファイル](#mysql設定ファイル)
  + `data`     [#mysqlデータフォルダ](#mysqlデータフォルダ)
  + `dump`     [#mysqlデータダンプフォルダ](#mysqlデータダンプフォルダ)
  + `scripts`  [#ハンズオン用スクリプト](#ハンズオン用スクリプト)
  + `sql`      [#sqlスクリプトダンプファイル置き場](#sqlスクリプトダンプファイル置き場)

### MySQL Server バイナリフォルダ

各バージョンの MySQL Server バイナリ (`mysqld`) を展開しているフォルダです。  
各バージョンの `mysqld` は、以下のように配置されています。

* MySQL Server 5.7: `$MYSQL_DIR/57/bin/mysqld`
* MySQL Server 8.0: `$MYSQL_DIR/80/bin/mysqld`
* MySQL Server 8.4: `$MYSQL_DIR/84/bin/mysqld`
* MySQL Server 9.0: `$MYSQL_DIR/90/bin/mysqld`

### MySQL Shell バイナリフォルダ

各バージョンの MySQL Shell バイナリ (`mysqlsh`) を展開しているフォルダです。  
各バージョンの `mysqlsh` は、以下のように配置されています。

* MySQL Shell 8.0: `$MYSQL_DIR/80sh/bin/mysqlsh`
* MySQL Shell 8.4: `$MYSQL_DIR/84sh/bin/mysqlsh`
* MySQL Shell 9.0: `$MYSQL_DIR/90sh/bin/mysqlsh`

### MySQL設定ファイル

各バージョンの MySQL Server の起動設定ファイルを保存しているフォルダです。

* MySQL Server 5.7: `$MYSQL_DIR/configs/my57.cnf`
* MySQL Server 5.7: `$MYSQL_DIR/configs/my57_gtid.cnf` (レプリケーションのソースになるために GTID 設定を追加)
* MySQL Server 8.0: `$MYSQL_DIR/configs/my80.cnf`
* MySQL Server 8.4: `$MYSQL_DIR/configs/my84.cnf`
* MySQL Server 9.0: `$MYSQL_DIR/configs/my90.cnf`

### MySQLデータフォルダ

各バージョンの MySQL Server のデータを保存するためのフォルダです。  
ハンズオンの手順で各 MySQL を初期化する際にデータが作られるため、初期は空フォルダです。  
ハンズオンの各手順でエラーが発生した場合には、各バージョンフォルダ内のデータを削除し、起動した MySQL Server を停止した後、再度実行すれば復帰します。

* MySQL Server 5.7: `$MYSQL_DIR/data/57`
* MySQL Server 8.0: `$MYSQL_DIR/data/80`
* MySQL Server 8.4: `$MYSQL_DIR/data/84`
* MySQL Server 9.0: `$MYSQL_DIR/data/90`

### MySQLデータダンプ置き場

MySQL Shell のインスタンスダンプユーティリティを用いたデータダンプの置き場です。  
本フォルダ下に、`57`、`80`のような形でダンプフォルダが生成されます。  
ハンズオンのダンプ手順でエラーが発生した場合には、各バージョンのダンプフォルダごと削除し、復帰してください。

### ハンズオン用スクリプト

#### 機能別スクリプト
1シェルファイル当たり1機能のスクリプトです。  
`57`、`80`など各サーバー向けのバージョンのフォルダがあり、各々に各機能のスクリプトがあります（ハンズオン手順の都合によりないものもあります）。  
機能の一覧は以下の通りです。

* `checkGTIDVar.sh`: レプリケーションに必要な、`gtid_mode` システム変数の値を確認します。
* `checkRepl.sh`: 接続先サーバーをレプリカとした、レプリケーションの状況を表示します。
* `checkUpgradeTo##.sh`: ##バージョンの MySQL Server へのアップグレードチェッカーを走らせます。
* `cloneTo##.sh`: ##バージョンの MySQL Server データフォルダに、データを CLONE プラグインでクローンします。
* `connectDB.sh`: MySQL Server に MySQL Shell で接続します。
* `dumpData.sh`: MySQL Shell のインスタンスダンプユーティリティで、MySQL データダンプ置き場にダンプを出力します。
* `initDB.sh`: MySQL データフォルダのデータを初期化します。
* `loadDumpFrom##.sh`: ##バージョンの MySQL Server でダンプしたデータダンプをロードします。
* `resetRepl.sh`: 接続先サーバーをレプリカとした、レプリケーションをリセットします。
* `setupClonePlugin.sh`: CLONE プラグインを有効にします。
* `setupReplFrom##.sh`: ##バージョンの MySQL Server をソースとし、接続先サーバーをレプリカとした、レプリケーションを設定します。
* `loadSQL.sh`: SQLスクリプト置き場から、world データベースを読み込みます。
* `showDBs.sh`: MySQL Server 内のデータベース一覧を表示します。
* `startDB.sh`: MySQL Server を起動し、バックグラウンド常駐させます。 
* `startDBwGTID.sh`: MySQL Server 5.7 のみ、GTID を有効にして起動するスクリプトです。
* `startRepl.sh`: 接続先サーバーをレプリカとした、レプリケーションを開始します。
* `stopDB.sh`: MySQL Server をシャットダウンし、常駐を解除します。
* `stopRepl.sh`: 接続先サーバーをレプリカとした、レプリケーションを停止します。
* `testReplFrom##/sh`: ##バージョンの MySQL Server をソースとし、接続先サーバーをレプリカとした、レプリケーションでデータ更新の伝播をテストします。

実際に各スクリプトが実行している処理については、各スクリプト内を参照してください。

#### シナリオスクリプト
ハンズオンの手順に従った実行ファイルです。  
`handson`フォルダの下に3ファイル設置されています。  
詳細は[ハンズオン手順](../README.md#ハンズオン手順)を参照してください。

### SQLスクリプト置き場

`world`データベースを設定する、`world.sql`が置かれています。
