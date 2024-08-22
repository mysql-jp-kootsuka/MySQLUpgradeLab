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
* ワークショップ後X日間はインスタンスを保持しますので、自習などにご利用ください。<br>その後は予告なく削除いたします。

## 環境説明

提供される環境は、ハンズオンのルートディレクトリ (ワークショップでは`/home/opc/mysql`) を`$MYSQL_DIR`として、以下のようになります。

```
-+ $MYSQL_DIR
 +- [57](#MySQLバイナリフォルダ)
 +- [80](#mysqlバイナリフォルダ)
 +- [80sh](#mysql-shellバイナリフォルダ)
 +- [84](#mysqlバイナリフォルダ)
 +- [84sh](#mysql-shellバイナリフォルダ)
 +- [90](#mysqlバイナリフォルダ)
 +- [90sh](#mysql-shellバイナリフォルダ)
 +- [configs](#mysql設定ファイル)
 +- [data](#mysqlデータフォルダ)
 +- [scripts](#ハンズオン用スクリプト)
 +- [sql](#sqlスクリプトダンプファイル置き場)
```

### MySQLバイナリフォルダ


### MySQL Shellバイナリフォルダ

### MySQL設定ファイル

### MySQLデータフォルダ

### ハンズオン用スクリプト

### SQLスクリプト/ダンプファイル置き場