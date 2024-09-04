# 環境構築

ハンズオンでは構築済みの環境が提供されますが、本Githubレポジトリでは、既存のLinux環境でもハンズオンと同様の環境を作るためのスクリプトを提供しています。  
`extraScripts`の下にそれらのスクリプトは配置しておりますので、以下の手順に従って設定してください。

**注:** 本スクリプトが動作するのは Linux 環境 (Windows の WSL 環境には対応) のみですが、主にDLするバイナリが Linux 版のものであることが理由ですので、ダウンロードするバイナリを他プラットフォームのものに置き換えれば、Mac などでも動作することが期待されます。

## 設定フォルダ

作業をするユーザーに権限があるフォルダに、本レポジトリの内容を`git clone`してください。

```
git clone https://github.com/mysql-jp-kootsuka/MySQLUpgradeLab.git
```

たとえば、作業フォルダが`/home/opc`であった場合、レポジトリは`/home/opc/MySQLUpgradeLab`に展開されるはずです。  
このレポジトリを展開したフォルダの一つ上のフォルダ（例の場合`/home/opc`）を、以後`$PROJECT_DIR`と呼びます。  
本ドキュメントの手順を実施すると、ハンズオン環境は`$PROJECT_DIR/mysql`に展開されます。

実行する設定スクリプトは、

1. `./extractScripts/01-dbDL.sh`
2. `./extractScripts/02-sqlDL.sh`
3. `./extractScripts/03-extract.sh`

の3つあり、これを順に実行すると、ハンズオン環境が構築されます。

### ./extractScripts/01-dbDL.sh

MySQL Server と MySQL Shell の各バージョン (5.7、8.0、8.4、9.0) のバイナリをダウンロードし、配置します。  
実行すると、以下のフォルダとその下に各バイナリを展開します。

* `$PROJECT_DIR/mysql/57`
* `$PROJECT_DIR/mysql/80`
* `$PROJECT_DIR/mysql/80sh`
* `$PROJECT_DIR/mysql/84`
* `$PROJECT_DIR/mysql/84sh`
* `$PROJECT_DIR/mysql/90`
* `$PROJECT_DIR/mysql/90sh`

このスクリプトのみ、各バイナリをダウンロードするための Oracle アカウントを聞かれますので、Oracle のアカウント（メールアドレス）とパスワードを入力してください。

### ./extractScripts/02-sqlDL.sh

実行すると、テストデータベースである `world` データベースを構築する SQL をダウンロードして、

* `$PROJECT_DIR/mysql/scripts/world.sql`

として配置します。

### ./extractScripts/03-extract.sh

前の 2 スクリプト以外のハンズオン環境を作成します。

----

この 3 つのスクリプトを実行すると、[ハンズオン](../README.md#ハンズオン手順)を実行できる環境が作られます。

## カスタマイズ

通常で動作させると上記の通り動作しますが、設定ファイルを用いて動作を多少カスタマイズできます。

### common.txt

設定ファイルは`common.txt`です。  
テンプレートとして`common.txt.template`を置いていますので、それを修正して設定ファイルとしてください。

テンプレートファイル`common.txt`の例:
```
GIVEN_DIR=/home/opc
SSO_USERNAME=name@oracle.com
```

設定項目は以下の通りです。

#### GIVEN_DIR

ハンズオン環境をインストールする先を変更します。  
これを設定すると、ハンズオン環境は`$GIVEN_DIR/mysql`に作られます。

#### SSO_USERNAME

`01-dbDL.sh`を動作させるときの、Oracle アカウントを事前設定しておきます。  
パスワードは保存しませんので、パスワードは都度入力が必要です。
