# AWS-Format.sh

## Overview

AWSを無料枠の範囲で試用したいので、削除忘れがないように
以下サービスで作ったインスタンスもろもろ全部削除します。

* EC2(停止のみで削除しない)
* ロードバランサ
* ターゲットグループ
* RDS

## Requirement

* awscliのインストールと基本設定

## Usage

```
./aws-format.sh
```
