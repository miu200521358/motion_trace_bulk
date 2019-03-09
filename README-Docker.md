# MotionTraceBulk - Docker版

このプログラムは、MMDモーショントレース自動化処理をまとめて実行するバッチプログラムです。

このドキュメントには Docker 版固有の情報のみ書いてあります。
その他の情報は README.md を読んでください。

## 準備

1. Docker for Windows をインストール

※インストール後、Windows上のファイルにコンテナ内からアクセスできるよう、
Docker for Windows の設定(Settings)でShared Drivesの設定を行う必要があります。

※Shared Drivesの設定を行っても、ファイアウォールに遮断されてコンテナ内から
　ファイルにアクセスできないことがあります。その場合ファイアウォールの設定を変更しましょう。

## 実行方法

README.md に書かれている実行方法に従ってください。
ただし、実行するバッチプログラムは Docker フォルダの中の MotionTraceBulk_Docker.bat です。
